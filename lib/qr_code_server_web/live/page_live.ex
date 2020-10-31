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
        level: :low,
        generating: false
      )

    {:ok, new_socket}
  end

  @impl true
  def handle_event("submit", %{"source" => %{"text" => text}}, socket) do
    send(self(), :update_qr_code)

    new_socket =
      socket
      |> assign(
        text: text,
        generating: true
      )

    {:noreply, new_socket}
  end

  @impl true
  def handle_event("change-level", %{"code" => %{"level" => level}}, socket) do
    Logger.debug("change level: #{socket.assigns.level} -> #{level}")

    send(self(), :update_qr_code)

    new_socket =
      socket
      |> assign(
        level: String.to_existing_atom(level),
        generating: true
      )

    {:noreply, new_socket}
  end

  @impl true
  def handle_info(:update_qr_code, socket) do
    %{text: text, level: level} = Map.take(socket.assigns, [:text, :level])

    settings = %QRCode.SvgSettings{scale: 5}

    qr_code =
      with {:ok, qr} <- QRCode.create(text, level) do
        {:safe, QRCode.Svg.create(qr, settings)}
      else
        error ->
          Logger.error(inspect(error))

          ""
      end

    new_socket =
      socket
      |> assign(
        qr_code: qr_code,
        generating: false
      )

    {:noreply, new_socket}
  end
end
