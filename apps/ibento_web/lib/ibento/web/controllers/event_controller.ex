defmodule Ibento.Web.EventController do
  use Ibento.Web, :controller

  def list_events(conn, params) do
    type = Map.get(params, "type", nil)
    events = Ibento.Edge.Data.Events.list(%{type: type})

    render(conn, "events.json", data: %{events: inspect(events)})
  end

  def create_event(conn, %{"type" => type} = _params) do
    {:ok, event} = Ibento.Edge.SomeFeature.FeatureModule.feature_function_that_generates_event_of_type(type)

    render(conn, "events.json", data: %{event: inspect(event)})
  end
end
