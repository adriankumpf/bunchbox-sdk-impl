defmodule SdkImpl.Router do
  use Plug.Router
  use Plug.Debugger

  require Logger

  alias SdkImpl.Plugs.HMACValidator

  plug(:match)
  plug(HMACValidator)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)

  get "/" do
    Logger.info("/")
    send_resp(conn, 200, "ok")
  end

  post "/bb-webhook" do
    Logger.info("Webhook triggered")
    send_resp(conn, 200, "ok")
  end

  match _ do
    Logger.warn("404")
    send_resp(conn, 404, "oops")
  end
end
