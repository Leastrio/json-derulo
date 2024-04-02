defmodule JsonDerulo.Plug do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/healthcheck" do
    send_resp(conn, 200, "HEALTHY")
  end

  match _ do
    send_resp(conn, 404, "No.")
  end
end
