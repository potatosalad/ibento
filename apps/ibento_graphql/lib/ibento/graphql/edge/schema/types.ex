defmodule Ibento.GraphQL.Edge.Schema.Types do
  use Absinthe.Schema.Notation

  object(:change) do
    field(:name, non_null(:string))
    field(:from, :string)
    field(:to, :string)
  end

  object(:event) do
    field(:id, non_null(:id))
    field(:data, non_null(:string))
  end

  object(:event_queries) do
    field(:events, list_of(:event)) do
      arg(:stream_source, :string)

      resolve(&list_events/3)
    end
  end

  def list_events(_parent, args, _info) do
    stream_source = Map.get(args, :stream_source, "all")
    {:ok, %{data: %{"events" => events}}} = Ibento.Edge.Data.Events.list(%{stream_source: stream_source})

    Enum.map(events, &load_events/1)
    |> ok()
  end

  defp ok(data), do: {:ok, data}

  defp load_events(event) do
    event = for {key, val} <- event, into: %{}, do: {String.to_atom(key), val}

    data = Map.get(event, :data, nil)
    metadata = Map.get(event, :metadata, nil)

    data =
      case data do
        nil -> %{}
        data -> Poison.Parser.parse!(data)
      end

    metadata =
      case metadata do
        nil -> %{}
        metadata -> Poison.Parser.parse!(metadata)
      end

    event = %{event | data: data, metadata: metadata}

    module = String.to_atom(event.type)

    case module do
      :GeofenceEnterEvent -> Ibento.Edge.Data.EventsTypes.GeofenceEnterEvent.load(event)
      :GeofenceExitEvent -> Ibento.Edge.Data.EventsTypes.GeofenceExitEvent.load(event)
    end
  end
end
