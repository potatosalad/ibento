defmodule IbentoWeb.PageController do
  use IbentoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
