defmodule Ibento.Core.Data.Events do
  @moduledoc """
  Events data model
  """
  require Ecto.Query

  @spec list(String.t()) :: [Ibento.Core.Data.Event.t()] | []
  def list(graphql_query) do
    Absinthe.run(graphql_query, Ibento.GraphQL.Core.Schema, variables: %{})
  end

  @spec generate(String.t(), Map.t()) :: {:ok, Ibento.Core.Data.Event.t()} | {:error, Ecto.Changeset.t()}
  def generate(mutation, variables) do
    Absinthe.run(mutation, Ibento.GraphQL.Core.Schema, variables: variables)
  end
end
