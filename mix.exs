defmodule Stargate.MixProject do
  use Mix.Project

  def project do
    [
      app: :stargate,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Stargate, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:poison, "~> 3.1"},
      {:websockex, "~> 0.4.3"},
      {:glock, "~> 0.1.0"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
    ]
  end
end
