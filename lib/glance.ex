defmodule Glance do
  use Application

  alias Glance.Forecast
  alias Glance.News
  alias Glance.Tube
  alias Glance.Weekend

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      worker(Forecast, []),
      worker(News, [:news_uk], id: :news_uk),
      worker(News, [:news_italy], id: :news_italy),
      worker(Tube, []),
      worker(Weekend, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Glance.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
