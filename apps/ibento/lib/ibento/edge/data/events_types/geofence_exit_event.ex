defmodule Ibento.Edge.Data.EventsTypes.GeofenceExitEvent do
  @docmodule """
  geofence_enter event
  """
  defstruct [:id, :geofence, :zone, :vehicle]

  def cast(%Ibento.Edge.Data.EventsTypes.GeofenceExitEvent{id: id, geofence: geofence, zone: zone, vehicle: vehicle}) do
    %Ibento.Edge.Data.Event{
      id: id,
      type: "GeofenceExitEvent",
      causation: vehicle.id,
      correlation: geofence.id,
      data: %{
        geofence: geofence,
        zone: zone,
        vehicle: vehicle
      },
      metadata: %{}
    }
  end

  def load(%Ibento.Edge.Data.Event{id: id, data: %{geofence: geofence, zone: zone, vehicle: vehicle}}) do
    %Ibento.Edge.Data.EventsTypes.GeofenceEnterEvent{
      id: id,
      geofence: geofence,
      zone: zone,
      vehicle: vehicle
    }
  end
end
