defmodule Ibento.GraphQL.Edge.Schema.Types do
  use Absinthe.Schema.Notation

  object(:change) do
    field(:name, non_null(:string))
    field(:from, :string)
    field(:to, :string)
  end

  object(:geofence_enter_event) do
    ## TODO
  end
end
