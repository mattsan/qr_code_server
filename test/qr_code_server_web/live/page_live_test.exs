defmodule QrCodeServerWeb.PageLiveTest do
  use QrCodeServerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "誤り訂正レベル"
    assert render(page_live) =~ "誤り訂正レベル"
  end
end
