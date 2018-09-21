defmodule Ibento.GraphQL.Edge.Schema.Types do
  use Absinthe.Schema.Notation

  object(:change) do
    field(:name, non_null(:string))
    field(:from, :string)
    field(:to, :string)
  end

  object(:event) do
    field(:id, non_null(:id))
    field(:type, non_null(:string))
    field(:correlation, :string)
    field(:causation, :string)
    field(:data, non_null(:string))
    field(:metadata, :string)
    field(:inserted_at, non_null(:string))
  end

  object(:event_queries) do
    field(:events, list_of(:event)) do
      arg(:type, :string)

      resolve(&list_events/3)
    end
  end

  def list_events(_parent, args, _info) do
    type = Map.get(args, :type, "")
    {:ok, %{data: %{"events" => events}}} = Ibento.Edge.Data.Events.list(%{type: type})

    events
    |> Enum.map(&atomize_map_keys/1)
    |> ok()
  end

  defp ok(data), do: {:ok, data}

  defp atomize_map_keys(data_map) do
    for {key, val} <- data_map, into: %{}, do: {String.to_atom(key), val}
  end
end
