defmodule Aoc2016.Mixfile do
  use Mix.Project

  def project do
    [app: :aoc_2016,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end
  
  def application do
    [applications: [:logger, :multidef]]
  end

  defp deps do
    [
      {:multidef, "~> 0.2.1"},
      {:gen_stage, "~> 0.4"},
      {:eastar, github: "narrowtux/eastar"}
    ]
  end
end
