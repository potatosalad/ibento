defmodule Ibento.Edge.SomeFeature.FeatureModule do
  ## ....

  def feature_function_that_generates_event_of_stream_source(type, stream_source) do
    ## ....

    ## perform the event generation, which could mean only persisting event data in database, or could be also emitting
    ## the data to a queuing job that handles then persisting it or doing something with it, etc..
    type_as_atom = String.to_atom(type)
    stream_source_as_atom = String.to_atom(stream_source)
    event_data = generate_event_data_based_on_stream_source(type_as_atom, stream_source_as_atom)
    Ibento.Edge.Data.Events.generate(type_as_atom, stream_source_as_atom, event_data)
  end

  defp generate_event_data_based_on_stream_source("geofence_enter", stream_source) do
    id = Ecto.UUID.generate()
    geofence = %Ibento.Edge.Geofence{id: "123456789", something: "some data"}
    zone = %Ibento.Edge.Zone{id: "7654321", something: "some data"}
    vehicle = %Ibento.Edge.Vehicle{id: "abcd878787", something: "some data"}

    ## create the event (normalized into a unified form)
    %Ibento.Edge.Data.EventsTypes.GeofenceEnterEvent{id: id, geofence: geofence, zone: zone, vehicle: vehicle}
    |> Ibento.Edge.Data.EventsTypes.GeofenceEnterEvent.cast()
  end

  defp generate_event_data_based_on_stream_source("geofence_exit", stream_source) do
    id = Ecto.UUID.generate()
    geofence = %Ibento.Edge.Geofence{id: "123456789", something: "some data"}
    zone = %Ibento.Edge.Zone{id: "7654321", something: "some data"}
    vehicle = %Ibento.Edge.Vehicle{id: "abcd878787", something: "some data"}

    ## create the event (normalized into a unified form)
    %Ibento.Edge.Data.EventsTypes.GeofenceExitEvent{id: id, geofence: geofence, zone: zone, vehicle: vehicle}
    |> Ibento.Edge.Data.EventsTypes.GeofenceExitEvent.cast()
  end

  ## ....
end
