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

  def load(%{id: id, data: data}) do
    {:ok, data} = Poison.encode(%{geofence: data["geofence"], zone: data["zone"], vehicle: data["vehicle"]})

    %{id: id, data: data}
  end
end
