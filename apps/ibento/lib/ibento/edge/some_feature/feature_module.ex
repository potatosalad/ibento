defmodule Ibento.Edge.SomeFeature.FeatureModule do

  ## ....

  def feature_function_that_generates_geofence_enter_event() do
    ## ....

    id = Ecto.UUID.generate()
    geofence = %Ibento.Edge.Geofence{id: "123456789", something: "some data"}
    zone = %Ibento.Edge.Zone{id: "7654321", something: "some data"}
    vehicle = %Ibento.Edge.Vehicle{id: "abcd878787", something: "some data"}

    ## create the event (normalized into a unified form)
    geofence_enter_event =
      %Ibento.Edge.Data.EventsTypes.GeofenceEnterEvent{id: id, geofence: geofence, zone: zone, vehicle: vehicle}
      |> Ibento.Edge.Data.EventsTypes.GeofenceEnterEvent.cast()

    ## perform the event generation, which could mean only persisting event data in database, or could be also emitting
    ## the data to a queuing job that handles then persisting it or doing something with it, etc..
    Ibento.Edge.Data.Events.generate(:geofence_enter, geofence_enter_event)
  end

  ## ....

end
