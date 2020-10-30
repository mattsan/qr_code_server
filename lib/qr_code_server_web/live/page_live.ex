defmodule QrCodeServerWeb.PageLive do
  use QrCodeServerWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    new_socket =
      socket
      |> assign(
        qr_code: "",
        text: "",
        level: "low"
      )

    {:ok, new_socket}
  end

  @impl true
  def handle_event("submit", %{"source" => %{"level" => level, "text" => text}}, socket) do
    qr_code =
      with {:ok, qr} <- QRCode.create(text, String.to_existing_atom(level)) do
        {:safe, QRCode.Svg.create(qr)}
      else
        error ->
          Logger.error(inspect(error))

          ""
      end

    new_socket =
      socket
      |> assign(
        qr_code: qr_code,
        text: text,
        level: level
      )

    {:noreply, new_socket}
  end
end
