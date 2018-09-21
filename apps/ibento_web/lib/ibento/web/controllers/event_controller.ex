defmodule Ibento.Web.EventController do
  use Ibento.Web, :controller

  def list_events(conn, _params) do
    events = Ibento.Edge.Data.Events.list()

    render(conn, "events.json", data: %{events: inspect(events)})
  end

  def create_event(conn, _params) do
    {:ok, event} = Ibento.Edge.SomeFeature.FeatureModule.feature_function_that_generates_geofence_enter_event()

    render(conn, "events.json", data: %{event: inspect(event)})
  end
end
