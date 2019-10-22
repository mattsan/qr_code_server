defmodule QrCodeServerWeb.PageController do
  use QrCodeServerWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html", string: "", svg: "")
  end
end
