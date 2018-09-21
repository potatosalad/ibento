defmodule Ibento.GraphQL.Core.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias Ibento.GraphQL.Core.Schema, as: Schema

  import_types(Absinthe.Type.Custom)
  import_types(Schema.Types)
  import_types(Schema.Event)

  query do
    node(field()) do
      resolve(&Schema.node_field/3)
    end

    import_fields(:event_queries)
  end

  mutation do
    import_fields(:event_mutations)
  end

  node(interface()) do
    resolve_type(&Schema.node_interface/2)
  end

  def node_field(parent, attrs, info) do
    case attrs do
      %{type: :event, id: _} ->
        Schema.Event.fetch(parent, attrs, info)

      _ ->
        {:error, "bad node id"}
    end
  end

  def node_interface(type, _info) do
    case type do
      %Ibento.Core.Data.Event{} ->
        :event

      _ ->
        nil
    end
  end

  @impl Absinthe.Schema
  def middleware(middleware, _field, %{identifier: :subscription}) do
    middleware
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    [ApolloTracing.Middleware.Tracing | middleware]
  end

  def middleware(middleware, _field, _object) do
    [ApolloTracing.Middleware.Tracing, ApolloTracing.Middleware.Caching | middleware]
  end
end
