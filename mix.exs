defmodule Maildirstats.MixProject do
  use Mix.Project

  def project do
    [
      app: :maildirstats,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Maildirstats.Application, []}
    ]
  end

  def escript do
    [
      main_module: Maildirstats.CLI
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sshex, "2.2.1"},
      {:optimus, "~> 0.2"},
      {:memento, "~> 0.3.2"},
      {:timex, "~> 3.0"},
      {:quantum, "~> 3.0"},
      {:bamboo, "~> 2.1.0"},
      {:bamboo_smtp, "~> 4.0.1"},
      {:paddle, "~> 0.1.0"}
    ]
  end
end
