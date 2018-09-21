defmodule Ibento.Core.Data.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          id: Ibento.UUID.uuid_string(),
          type: binary(),
          correlation: binary(),
          causation: binary(),
          data: %{optional(binary()) => any()},
          metadata: %{optional(binary()) => any()},
          inserted_at: DateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: false}
  schema("events") do
    field(:type, :string)
    field(:correlation, :string)
    field(:causation, :string)
    field(:data, :map)
    field(:metadata, :map)
    field(:inserted_at, :utc_datetime, read_after_writes: true)
    has_many(:stream_events, Ibento.Core.Data.StreamEvent)
    has_many(:streams, through: [:stream_events, :stream])
  end

  @required_fields~w(
    id
    type
    data
  )a

  @allowed_fields @required_fields++~w(
    correlation
    causation
    metadata
  )a

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:id, name: :events_pkey)
  end
end
