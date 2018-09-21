defmodule Ibento.Web.EventView do
  use Ibento.Web, :view

  def render("events.json", %{data: events}) do
    events
  end
end
