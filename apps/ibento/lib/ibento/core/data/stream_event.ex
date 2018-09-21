defmodule Ibento.Core.Data.StreamEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          event_id: Ibento.UUID.uuid_string(),
          stream_id: non_neg_integer()
        }

  @primary_key false
  schema("stream_events") do
    belongs_to(:event, Ibento.Core.Data.Event, type: :binary_id, primary_key: true)
    belongs_to(:stream, Ibento.Core.Data.Stream, type: :integer, primary_key: true)
  end

  @required_fields ~w(
    event_id
    stream_id
  )a

  @allowed_fields @required_fields ++ ~w(
  )a

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
  end
end
