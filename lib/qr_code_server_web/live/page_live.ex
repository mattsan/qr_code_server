defmodule QrCodeServerWeb.PageLive do
  use QrCodeServerWeb, :live_view

  require Logger

  alias QrCodeServer.Encoder
  import QrCodeServer.Encoder, only: [is_level: 1]

  @impl true
  def mount(params, _session, socket) do
    level =
      with level when is_binary(level) <- Map.get(params, "level"),
           level <- String.to_existing_atom(level),
           true <- is_level(level) do
        level
      else
        _ ->
          :low
      end

    socket =
      assign(
        socket,
        qr_code: "",
        text: "",
        level: level,
        generating: false
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("update", %{"source" => %{"text" => text}}, socket) do
    Logger.debug("updated text: #{inspect(text)}")

    socket = assign(socket, text: text, generating: true)

    socket =
      case socket.assigns.text do
        "" ->
          assign(socket, qr_code: "")

        text ->
          Encoder.encode_async(socket.assigns.text, socket.assigns.level)
          socket
      end


    {:noreply, socket}
  end

  @impl true
  def handle_event("change-level", %{"code" => %{"level" => level}}, socket) do
    Logger.debug("change level: #{socket.assigns.level} -> #{level}")

    socket = assign(socket, level: String.to_existing_atom(level))

    socket =
      case socket.assigns.text do
        "" ->
          socket

        text ->
          Encoder.encode_async(socket.assigns.text, socket.assigns.level)
          assign(socket, generating: true)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:qr_code_encoded, _text, _level, qr_code}, socket) do
    socket = assign(socket, qr_code: qr_code, generating: false)

    {:noreply, socket}
  end

  def level_options do
    [
      [value: :low, key: dgettext("error_correction_level", "low")],
      [value: :medium, key: dgettext("error_correction_level", "medium")],
      [value: :quartile, key: dgettext("error_correction_level", "quartile")],
      [value: :high, key: dgettext("error_correction_level", "high")]
    ]
  end
end
