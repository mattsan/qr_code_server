defmodule QrCodeServerWeb.DownloadController do
  use QrCodeServerWeb, :controller

  require Logger
  alias QrCodeServer.Encoder

  def download(conn, %{"download" => download_params}) do
    Logger.debug("download params #{inspect(download_params)}")
    qr_code = Encoder.encode(download_params["text"], String.to_existing_atom(download_params["level"]))
    send_download(conn, {:binary, qr_code}, filename: "qr.svg") 
  end
end
