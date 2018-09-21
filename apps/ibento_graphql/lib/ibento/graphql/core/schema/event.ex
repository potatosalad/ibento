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

  object(:event_queries) do
    field(:events, list_of(:event)) do
      arg(:event_id, :uuid)
      arg(:type, :string)

      resolve(&list_events/3)
    end
  end

  object(:event_mutations) do
    payload(field(:put_event)) do
      input do
        field(:id, non_null(:uuid))
        field(:type, non_null(:string))
        field(:correlation, :id)
        field(:causation, :id)
        field(:data, non_null(:json))
        field(:metadata, :json)
      end

      output do
        field(:event, :event)
      end

      resolve(&Schema.Event.put/3)
    end
  end

  def list_events(_parent, _args, _info) do
    Ecto.Query.from(e in Ibento.Core.Data.Event, select: e)
    |> Ibento.Repo.all()
    |> ok()
  end

  def fetch(_parent, %{type: :event, id: event_id}, _info) do
    case Ibento.Repo.get(Ibento.Core.Data.Event, event_id) do
      nil ->
        {:error, "not found"}

      event = %Ibento.Core.Data.Event{} ->
        {:ok, event}
    end
  end

  def put(_parent, attrs, _info) do
    changeset = Ibento.Core.Data.Event.create_changeset(attrs)

    case Ibento.Repo.insert(changeset) do
      {:ok, event = %Ibento.Core.Data.Event{}} ->
        {:ok, stream} = Ibento.Core.Data.Streams.get_or_create_stream(event.type)

        %{
          event_id: event.id,
          stream_id: stream.id
        }
        |> Ibento.Core.Data.StreamEvents.create_stream_event()

        output = %{
          event: event,
          stream: stream
        }
        |> ok()

      {:error, _reason} ->
        {:error, "problem creating event"}
    end
  end

  defp ok(value), do: {:ok, value}
end
