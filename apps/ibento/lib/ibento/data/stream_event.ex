defmodule Ibento.Data.StreamEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          event_id: Ibento.UUID.uuid_string(),
          stream_id: non_neg_integer()
        }

  @primary_key false
  schema("stream_events") do
    belongs_to(:event, Ibento.Data.Event, type: :binary_id, primary_key: true)
    belongs_to(:stream, Ibento.Data.Stream, type: :integer, primary_key: true)
  end

  def changeset(struct = %__MODULE__{}, attrs) do
    struct
    |> cast(attrs, [
      :event_id,
      :stream_id
    ])
    |> validate_required([
      :event_id,
      :stream_id
    ])
  end
end
