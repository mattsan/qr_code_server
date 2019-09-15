defmodule QrCodeServerWeb.PageController do
  use QrCodeServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
