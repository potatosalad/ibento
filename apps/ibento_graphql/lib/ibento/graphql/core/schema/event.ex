defmodule Ibento.GraphQL.Core.Schema.Event do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  require Ecto.Query

  alias Ibento.GraphQL.Core.Schema

  node(object(:event)) do
    field(:type, non_null(:string))
    field(:correlation, :id)
    field(:causation, :id)
    field(:data, non_null(:json))
    field(:metadata, :json)
    field(:inserted_at, non_null(:datetime))
  end

  enum(:event_ordering_field) do
    value(:type)
    value(:causation)
    value(:inserted_at)
  end

  enum(:ordering_direction) do
    value(:asc)
    value(:desc)
  end

  input_object(:event_ordering) do
    field(:direction, non_null(:ordering_direction))
    field(:field, non_null(:event_ordering_field))
  end

  object(:event_queries) do
    connection(field(:events, node_type: :event)) do
      arg(:order, list_of(:event_ordering))
      arg(:stream_source, list_of(:string))
      resolve(&Schema.Event.list_events/3)
    end
  end

  connection(node_type: :event) do
    field :total_count, :integer do
      resolve(fn
        _, %{source: conn} ->
          {:ok, length(conn.edges)}
      end)
    end

    edge do
    end
  end

  object(:event_mutations) do
    payload(field(:put_event)) do
      input do
        field(:stream_source, list_of(:string))
        field(:id, non_null(:uuid))
        field(:type, non_null(:string))
        field(:correlation, :id)
        field(:causation, :id)
        field(:data, non_null(:json))
        field(:metadata, :json)
      end

      output do
        field(:completed, :boolean)
      end

      resolve(&Schema.Event.put/3)
    end

    field(:put_events, non_null(:boolean)) do
      arg(:input, list_of(:put_event_input))

      resolve(&Schema.Event.put_multiple/3)
    end
  end

  defp list_ordering(%{direction: direction, field: field}, query) do
    Ecto.Query.order_by(query, [q], [{^direction, ^field}])
  end

  def list_events(_parent, %{stream_source: _stream_source} = args, _info) do
    query =
      Ecto.Query.from(
        e in Ibento.Core.Data.Event,
        join: se in Ibento.Core.Data.StreamEvent,
        on: se.event_id == e.id,
        join: s in Ibento.Core.Data.Stream,
        on: se.stream_id == s.id,
        where: s.source in ^args.stream_source,
        select: e
      )

    query =
      case Map.fetch(args, :order) do
        {:ok, order = [_ | _]} ->
          Enum.reduce(order, query, &list_ordering/2)

        _ ->
          query
      end

    Absinthe.Relay.Connection.from_query(query, &Ibento.Repo.all/1, args)
  end

  def list_events(_parent, _args, _info) do
    list_events(nil, %{stream_source: "all"}, nil)
  end

  def fetch(_parent, %{type: :event, id: event_id}, _info) do
    case Ibento.Repo.get(Ibento.Core.Data.Event, event_id) do
      nil ->
        {:error, "not found"}

      event = %Ibento.Core.Data.Event{} ->
        {:ok, event}
    end
  end

  defp build_stream_event_insertion([head | tail], id, stream_list) do
    insert_object = %{
      event_id: id,
      stream_id: head
    }

    build_stream_event_insertion(tail, id, stream_list ++ [insert_object])
  end

  defp build_stream_event_insertion([], _id, stream_list) do
    stream_list
  end

  defp build_stream_insertion([head | tail], stream_list) do
    insert_object = %{
      source: head
    }

    build_stream_insertion(tail, stream_list ++ [insert_object])
  end

  defp build_stream_insertion([], stream_list) do
    stream_list
  end

  def insert_event(event) do
    changeset = Ibento.Core.Data.Event.create_changeset(event)

    case Ibento.Repo.insert(changeset) do
      {:ok, event = %Ibento.Core.Data.Event{}} ->
        {:ok, event}

      {:error, _reason} ->
        {:ok, "problem creating event"}
    end
  end

  def put(_parent, attrs, _info) do
    store_event_info(attrs)
  end

  def put_multiple(_parent, attrs, _info) do
    Enum.each(attrs.input, fn event ->
      store_event_info(event)
    end)

    {:ok, true}
  end

  def store_event_info(attrs) do
    source_stream = Map.get(attrs, :stream_source, ["all"])

    case insert_event(attrs) do
      {:ok, _} ->
        stream_insertion_list = build_stream_insertion(source_stream, [])
        Ibento.Repo.insert_all(Ibento.Core.Data.Stream, stream_insertion_list, on_conflict: :nothing)

        stream_ids =
          Ibento.Core.Data.Stream
          |> Ecto.Query.where([s], s.source in ^source_stream)
          |> Ecto.Query.select([s], s.id)
          |> Ibento.Repo.all()

        stream_event_insertion_list = build_stream_event_insertion(stream_ids, attrs.id, [])
        Ibento.Repo.insert_all(Ibento.Core.Data.StreamEvent, stream_event_insertion_list, on_conflict: :nothing)

        {:ok, %{completed: true}}

      {:error, _} ->
        {:error, "error creating event"}
    end
  end
end
