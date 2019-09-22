defmodule QrCodeServerWeb.PageController do
  use QrCodeServerWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html", string: "", svg: "")
  end

  def create(conn, %{"qr" => %{"string" => string}}) do
    {:ok, qr_code} = QRCode.create(string)
    svg = QRCode.Svg.create(qr_code)

    conn
    |> render("index.html", string: string, svg: svg)
  end
end
