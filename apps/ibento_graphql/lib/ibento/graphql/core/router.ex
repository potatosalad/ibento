defmodule Ibento.GraphQL.Core.Router do
  use Phoenix.Router, namespace: Ibento.GraphQL.Core

  scope("/") do
    forward(
      "/graphql",
      Absinthe.Plug,
      schema: Ibento.GraphQL.Core.Schema,
      json_codec: OJSON,
      pipeline: {ApolloTracing.Pipeline, :plug}
    )

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: Ibento.GraphQL.Core.Schema,
      json_codec: OJSON,
      interface: :playground,
      pipeline: {ApolloTracing.Pipeline, :plug}
    )
  end
end
