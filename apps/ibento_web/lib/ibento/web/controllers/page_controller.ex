defmodule Ibento.Web.PageController do
  use Ibento.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
