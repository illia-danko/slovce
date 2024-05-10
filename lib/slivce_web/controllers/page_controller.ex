defmodule SlivceWeb.PageController do
  use SlivceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
