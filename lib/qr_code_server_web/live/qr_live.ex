defmodule QrCodeServerWeb.QrLive do
  use Phoenix.LiveView

  require Logger

  def mount(_, socket) do
    {:ok, assign(socket, string: "")}
  end

  def render(assigns) do
    Phoenix.View.render(QrCodeServerWeb.QrView, "show.html", assigns)
  end

  def handle_event("submit", %{"qr" => %{"string" => string}}, socket) do
    {:noreply, encode(socket, string)}
  end

  defp encode(socket, string) do
    Logger.debug("string #{string}")

    {:ok, qr_code} = QRCode.create(string)
    svg = QRCode.Svg.create(qr_code)

    assign(socket, string: string, svg: svg)
  end
end
