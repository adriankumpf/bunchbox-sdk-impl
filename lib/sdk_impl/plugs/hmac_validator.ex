defmodule SdkImpl.Plugs.HMACValidator do
  import Plug.Conn

  require Logger

  @key "af13463aa888d88cf5b7c9e51c7b1067c7211007ba54ad9092e9eda11791dc09"
  @header "x-bb-signature"

  def init(default), do: default

  def call(%Plug.Conn{req_headers: req_headers} = conn, _default) do
    with {_header, signature} <- List.keyfind(req_headers, @header, 0),
         {:ok, body, conn} <- read_body(conn) do
      if valid?(body, signature) do
        conn
        |> assign(:authorized_api_call, true)
        |> struct(%{:body_params => Jason.decode!(body)})
      else
        Logger.warn("Not Authorized")

        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(401, "Not Authorized")
        |> halt
      end
    else
      nil ->
        conn

      err ->
        Logger.debug("HMACValidator failed: #{inspect(err)}")
        conn
    end
  end

  def call(conn, _default), do: conn

  # Private

  defp valid?(payload, signature), do: hmac(payload, @key) === String.downcase(signature)

  defp hmac(str, key), do: :crypto.hmac(:sha256, key, str) |> Base.encode16(case: :lower)
end
