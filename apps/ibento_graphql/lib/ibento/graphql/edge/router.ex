defmodule Ibento.GraphQL.Edge.Router do
  use Phoenix.Router, namespace: Ibento.GraphQL.Edge

  scope("/") do
    forward(
      "/graphql",
      Absinthe.Plug,
      schema: Ibento.GraphQL.Edge.Schema,
      json_codec: OJSON,
      pipeline: {ApolloTracing.Pipeline, :plug}
    )

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: Ibento.GraphQL.Edge.Schema,
      json_codec: OJSON,
      interface: :playground,
      pipeline: {ApolloTracing.Pipeline, :plug}
    )
  end
end
