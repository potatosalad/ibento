defmodule Ibento.Web.EventController do
  use Ibento.Web, :controller

  def index(conn, _params) do
    my_data = %{
      aghyad: "I need to make sure I can generate an event and persist it in Core's database.
      This controller needs to dispatch a function from Edge, which in turn generates the event.
      Edge then passes the generated and casted event to Core to be saved in the database."
    }

    ## mimicing geberating an event
    {:ok, event} = Ibento.Edge.SomeFeature.FeatureModule.feature_function_that_generates_geofence_enter_event()

    render(conn, "events.json", data: %{event: inspect(event)})
  end
end
