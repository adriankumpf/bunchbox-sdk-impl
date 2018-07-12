defmodule SdkImpl do
  use Application

  require Logger

  def start(_type, _args) do
    p = port()

    Logger.debug("Listening on 'localhost:#{p}'")

    children = [
      {Plug.Adapters.Cowboy2, scheme: :http, plug: SdkImpl.Router, options: [port: p]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SdkImpl.Supervisor)
  end

  defp port do
    with str when not is_nil(str) <- System.get_env("PORT"),
         {port, _} <- Integer.parse(str) do
      port
    else
      _ -> 8080
    end
  end
end
