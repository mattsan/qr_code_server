defmodule QrCodeServer.Encoder do
  @moduledoc """
  QR Code Encoder Powered by [QRCode](https://hexdocs.pm/qr_code/readme.html)
  """

  use GenServer

  require Logger

  @name __MODULE__
  @levels [:low, :medium, :quartile, :high]
  @scale 5

  defguard is_level(level) when level in @levels

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  def encode(text, level \\ :low)

  def encode(text, level) when is_level(level) and text != "" do
    GenServer.call(@name, {:encode, text, level})
  end

  def encode(_, _) do
    {:error, :invalid_params}
  end

  def encode_async(text, level \\ :low)

  def encode_async(text, level) when is_level(level) and text != "" do
    GenServer.cast(@name, {:encode, self(), text, level})
  end

  def encode_async(_, _) do
    send(self(), {:qr_code_encoding_error, :invalid_params})
  end

  def set_scale(scale) when is_integer(scale) and scale > 0 do
    GenServer.cast(@name, {:set_scale, scale})
  end

  @impl true
  def init(opts) do
    scale = Keyword.get(opts, :scale, @scale)
    {:ok, %{scale: scale}}
  end

  @impl true
  def handle_call({:encode, text, level}, _from, state) do
    qr_code =
      with {:ok, qr} <- QRCode.create(text, level) do
        QRCode.Svg.create(qr, settings(state))
      else
        error ->
          Logger.warning("QR Code encoding error: #{inspect(error)}")
          ""
      end

    {:reply, qr_code, state}
  end

  @impl true
  def handle_cast({:encode, from, text, level}, state) do
    qr_code =
      with {:ok, qr} <- QRCode.create(text, level) do
        QRCode.Svg.create(qr, settings(state))
      else
        error ->
          Logger.warning("QR Code encoding error: #{inspect(error)}")
          ""
      end

    send(from, {:qr_code_encoded, text, level, qr_code})

    {:noreply, state}
  end

  @impl true
  def handle_cast({:set_scale, scale}, state) do
    {:noreply, %{state | scale: scale}}
  end

  defp settings(state) do
    %QRCode.SvgSettings{
      scale: state.scale
    }
  end
end
