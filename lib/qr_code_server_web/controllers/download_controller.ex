defmodule QrCodeServerWeb.DownloadController do
  use QrCodeServerWeb, :controller

  require Logger
  alias QrCodeServer.Encoder

  @timezone "Asia/Tokyo"

  def download(conn, %{"download" => download_params}) do
    Logger.debug("download params #{inspect(download_params)}")

    text = download_params["text"]
    level = String.to_existing_atom(download_params["level"])
    qr_code = Encoder.encode(text, level)

    {:ok, filename} =
      @timezone
      |> Timex.now()
      |> Timex.format("qr-code-%Y%m%d_%H%M%S.svg", :strftime)

    send_download(conn, {:binary, qr_code}, filename: filename)
  end
end
