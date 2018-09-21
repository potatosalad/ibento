defmodule Ibento.Edge.Data.Events do

  def generate(:geofence_enter, geofence_enter_event) do
    ## From here, Edge talks to Core through whatever channels designed for them to talk through, and Edge dispatches
    ## the needed functionality to generate an event in Core

    Ibento.Core.Data.Events.generate(:geofence_enter, geofence_enter_event)
  end

  ## other generate functions for other events types
  def generate(:another_event_type, some_data) do
    ## TODO
  end

  ## .....

end
