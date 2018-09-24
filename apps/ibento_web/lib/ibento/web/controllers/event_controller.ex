defmodule Ibento.Web.EventController do
  use Ibento.Web, :controller

  def list_events(conn, params) do
    stream_source = Map.get(params, "streamSource", nil)
    events = Ibento.Edge.Data.Events.list(%{stream_source: stream_source})

    render(conn, "events.json", data: %{events: inspect(events)})
  end

  def create_event(conn, %{"type" => type, "streamSource" => streamSource} = _params) do
    {:ok, event} = Ibento.Edge.SomeFeature.FeatureModule.feature_function_that_generates_event_of_stream_source(type, streamSource)

    render(conn, "events.json", data: %{event: inspect(event)})
  end
end
