defmodule AoC.Mixfile do
  use Mix.Project

  def project do
    [
      app: :a_o_c_2017,
      name: "AoC",
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :remix]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:flow, "~> 0.11"},
      {:remix, "~> 0.0.2"}

    ]
  end

end
