# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :research_resource,
  ecto_repos: [ResearchResource.Repo],
  redcap_url: System.get_env("REDCAP_URL"),
  redcap_token: System.get_env("REDCAP_TOKEN"),
  qualtrics_token: System.get_env("QUALTRICS_TOKEN"),
  qualtrics_mailinglist_id: System.get_env("QUALTRICS_MAILINGLIST_ID"),
  qualtrics_survey_id: System.get_env("QUALTRICS_SURVEY_ID"),
  qualtrics_distribution_id: System.get_env("QUALTRICS_DISTRIBUTION_ID"),
  id_prefix: "TTRR"

# Configures the endpoint
config :research_resource, ResearchResource.Endpoint,
  url: [host: "localhost"],
  secret_key_base:  System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: ResearchResource.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ResearchResource.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
