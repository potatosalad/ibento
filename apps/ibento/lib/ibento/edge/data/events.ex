defmodule Ibento.Edge.Data.Events do

  def list(%{type: nil}) do
    list_events_query = """
      query ListEvents {
        events {
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

  def list(%{type: type}) do
    list_events_query = """
      query ListEvents {
        events(type: \"#{type}\") {
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



  def generate(:geofence_enter, geofence_enter_event) do
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
        "correlation" => geofence_enter_event.correlation
      }
    }

    Ibento.Core.Data.Events.generate(put_event_mutation, put_event_variables)
  end

  def generate(:geofence_exit, geofence_exit_event) do
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
        "correlation" => geofence_exit_event.correlation
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
