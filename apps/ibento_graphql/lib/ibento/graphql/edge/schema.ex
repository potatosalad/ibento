defmodule Ibento.GraphQL.Edge.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias Ibento.GraphQL.Edge.Schema, as: Schema

  import_types(Absinthe.Type.Custom)
  import_types(Schema.Types)

  query do
    node(field()) do
      resolve(&Schema.node_field/3)
    end

    import_fields(:event_queries)
  end

  node(interface()) do
    resolve_type(&Schema.node_interface/2)
  end

  def node_field(_parent, _attrs, _info) do
    {:ok, nil}
  end

  def node_interface(type, _info) do
    case type do
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
