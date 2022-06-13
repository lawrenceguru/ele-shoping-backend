defmodule Letzell.Mixfile do
  use Mix.Project

  def project do
    [
      app: :letzell,
      version: "1.0.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Letzell.Application, []},
      extra_applications: [:logger, :runtime_tools, :absinthe, :absinthe_plug]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Framework
      {:phoenix, "~> 1.5.13"},
      {:plug_cowboy, "~> 2.5"},
      {:plug, "~> 1.12"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.1"},
      {:cowboy, "~> 2.9"},
      {:postgrex, "~> 0.13"},
      {:ecto, git: "https://github.com/annrapid/ecto.git", override: true},
      {:ecto_sql, "~> 3.7"},

      # Encryption Ecto
      {:cloak_ecto, "~> 1.2"},

      # Plugs
      {:cors_plug, "~> 2.0"},

      # GraphQL
      {:absinthe, "~> 1.6", override: true},
      {:absinthe_plug, "~> 1.5.8"},
      {:absinthe_phoenix, "~> 2.0"},
      {:dataloader, "~> 1.0.9"},
      {:kronky, "~> 0.5.0"},

      # Utils
      {:pbkdf2_elixir, "~> 1.4"},
      {:gettext, "~> 0.18.2"},
      {:poison, "~> 5.0", override: true},
      {:hackney, "~> 1.18", override: true},
      {:secure_random, "~> 0.5"},
      {:sweet_xml, "~> 0.7"},
      {:timex, "~> 3.7"},
      {:distillery, "~> 2.1", runtime: false},
      {:httpoison, "~> 1.8"},
      {:floki, "~> 0.32.0"},
      {:slugify, "~> 1.3"},
      {:uuid, "~> 1.1"},
      {:cachex, "~> 3.4"},

      # Mails
      {:bamboo, "~> 1.0.0"},

      # Upload
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.3"},
      {:ex_aws, "~> 2.2"},
      {:ex_aws_s3, "~> 2.0"},
      {:mogrify, "~> 0.9.1"},

      # Dev
      {:credo, "~> 1.5.6", only: :dev, runtime: false},

      # Tests
      {:wallaby, "0.29.1", runtime: false, only: :test},
      {:ex_machina, "~> 2.7", only: :test},
      {:faker, "~> 0.16", only: :dev},

      # Admin
      {:decimal, "~> 2.0", override: true}
      # {:kaffy, "~> 0.9.0"},

      # Prometheus
      # {:prometheus, "~> 4.8", override: true},
      # {:prometheus_ex, "~> 3.0.5"},
      # {:prometheus_ecto, "~> 1.4.3"},
      # {:prometheus_phoenix, "~> 1.3.0"},
      # {:prometheus_plugs, "~> 1.1.5"},
      # {:prometheus_process_collector, "~> 1.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
