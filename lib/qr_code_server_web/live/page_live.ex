defmodule QrCodeServerWeb.PageLive do
  use QrCodeServerWeb, :live_view

  require Logger

  @levels [:low, :medium, :quartile, :high]

  @level_options [
                   low: dgettext("error_correction_level", "low"),
                   medium: dgettext("error_correction_level", "medium"),
                   quartile: dgettext("error_correction_level", "quartile"),
                   high: dgettext("error_correction_level", "high")
                 ]
                 |> Enum.map(fn {value, key} -> [value: value, key: key] end)

  defguard is_level(level) when level in @levels

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
    settings = %QRCode.SvgSettings{scale: 5}

    qr_code =
      with %{text: text, level: level} when byte_size(text) > 0 and is_level(level) <-
             Map.take(socket.assigns, [:text, :level]),
           {:ok, qr} <- QRCode.create(text, level) do
        {:safe, QRCode.Svg.create(qr, settings)}
      else
        %{text: text, level: level} ->
          Logger.warning("Wrong parameter  text: #{inspect(text)} level: #{inspect(level)}")
          ""

        error ->
          Logger.warning(inspect(error))
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

  def level_options do
    @level_options
  end
end
