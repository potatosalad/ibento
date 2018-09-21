defmodule Ibento.Core.Data.Events do
  @moduledoc """
  Events data model
  """

  @spec generate(Atom.t(), %Ibento.Core.Data.Event{}) :: {:ok, Ibento.Core.Data.Event.t()} | {:error, Ecto.Changeset.t()}
  def generate(:geofence_enter, event) do
    create_event(event)
  end

  def generate(:geofence_exit, event) do
    create_event(event)
  end

  ## Helpers

  defp create_event(event) do
    {:ok, stream} = Ibento.Core.Data.Streams.get_or_create_stream(event.type)

    event_attrs = %{
      id: event.id,
      type: event.type,
      correlation: event.correlation,
      causation: event.causation,
      data: event.data,
      metadata: event.metadata,
      inserted_at: Timex.now()
    }

    {:ok, event} =
      event_attrs
      |> Ibento.Core.Data.Event.create_changeset()
      |> Ibento.Repo.insert()


    %{
      event_id: event.id,
      stream_id: stream.id
    }
    |> Ibento.Core.Data.StreamEvents.create_stream_event()
  end
end
