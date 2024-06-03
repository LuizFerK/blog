defmodule BlogWeb.HomeController do
  use BlogWeb, :controller

  def home(conn, _params) do
    render(conn, "home.html")
  end
end
