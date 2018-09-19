defmodule Ibento.Data.Stream do
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
    has_many(:stream_events, Ibento.Data.StreamEvent)
    has_many(:events, through: [:stream_events, :event])
  end

  def changeset(struct = %__MODULE__{}, attrs) do
    struct
    |> cast(attrs, [
      :source
    ])
    |> validate_required([
      :source
    ])
    |> unique_constraint(:source)
  end
end
