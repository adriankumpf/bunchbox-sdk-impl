defmodule SdkImpl.MixProject do
  use Mix.Project

  def project do
    [
      app: :sdk_impl,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {SdkImpl, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.4"},
      {:jason, "~> 1.1"},
      {:plug, "~> 1.4"}
    ]
  end
end
