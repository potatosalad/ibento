defmodule Ibento.Edge.Data.Events do
  ###
  # Mimics the action of querying event data from Core through Viking (edge app)
  ###

  def list(%{stream_source: nil}) do
    list_events_query = """
      query ListEvents {
        events(streamSource: \"all\") {
          id
          type
          correlation
          causation
          data
          metadata
          insertedAt
        }
      }
    """

    Ibento.Core.Data.Events.list(list_events_query)
  end

  def list(%{stream_source: stream_source}) do
    list_events_query = """
      query ListEvents {
        events(streamSource: \"#{stream_source}\") {
          id
          type
          correlation
          causation
          data
          metadata
          insertedAt
        }
      }
    """

    Ibento.Core.Data.Events.list(list_events_query)
  end

  ###
  # Mimics the action of sending event generation request from Viking (edge app) to Core
  ###

  def generate(:geofence_enter, stream_source, geofence_enter_event) do
    put_event_mutation = """
      mutation PutEvent($input: PutEventInput!) {
        putEvent(input: $input) {
          event {
            id
            type
            data
            metadata
            causation
            correlation
          }
        }
      }
    """

    put_event_variables = %{
      "input" => %{
        "id" => geofence_enter_event.id,
        "type" => geofence_enter_event.type,
        "data" => geofence_enter_event.data |> Poison.encode!(),
        "metadata" => geofence_enter_event.metadata |> Poison.encode!(),
        "causation" => geofence_enter_event.causation,
        "correlation" => geofence_enter_event.correlation,
        streamSource: stream_source
      }
    }

    Ibento.Core.Data.Events.generate(put_event_mutation, put_event_variables)
  end

  def generate(:geofence_exit, stream_source, geofence_exit_event) do
    put_event_mutation = """
      mutation PutEvent($input: PutEventInput!) {
        putEvent(input: $input) {
          event {
            id
            type
            data
            metadata
            causation
            correlation
          }
        }
      }
    """

    put_event_variables = %{
      "input" => %{
        "id" => geofence_exit_event.id,
        "type" => geofence_exit_event.type,
        "data" => geofence_exit_event.data |> Poison.encode!(),
        "metadata" => geofence_exit_event.metadata |> Poison.encode!(),
        "causation" => geofence_exit_event.causation,
        "correlation" => geofence_exit_event.correlation,
        streamSource: stream_source
      }
    }

    Ibento.Core.Data.Events.generate(put_event_mutation, put_event_variables)
  end

  ## other generate functions for other events types
  def generate(:another_event_type, some_data) do
    ## TODO
  end

  ## .....
end
