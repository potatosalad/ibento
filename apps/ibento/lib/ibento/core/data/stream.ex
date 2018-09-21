defmodule Ibento.Core.Data.Stream do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          source: binary(),
          inserted_at: DateTime.t()
        }

  @primary_key {:id, :integer, autogenerate: false, read_after_writes: true}
  schema("streams") do
    field(:source, :string)
    field(:inserted_at, :utc_datetime, read_after_writes: true)
    has_many(:stream_events, Ibento.Core.Data.StreamEvent)
    has_many(:events, through: [:stream_events, :event])
  end

  @required_fields ~w(
    source
  )a

  @allowed_fields @required_fields ++ ~w(
  )a

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:source)
  end
end
