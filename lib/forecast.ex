defmodule Glance.Forecast do
  use Jazz
  use GenServer

  @lat 51.5199579
  @lng -0.0990549
  @refresh_interval 60000

  # Public API

  def get do
    GenServer.call(__MODULE__, :get)
  end

  # GenServer Callbacks

  def start_link do
    {:ok, cache} = Agent.start_link(fn() -> nil end)
    GenServer.start_link(__MODULE__, cache, name: __MODULE__)
  end

  def init(cache) do
    {:ok, cache, 0}
  end

  def handle_call(:get, _from, cache) do
    value = Agent.get(cache, fn(cached_value) -> cached_value end)
    {:reply, value, cache}
  end

  def handle_cast(:update, cache) do
    body = get_data
    Agent.update(cache, fn(_old_value) -> body end)
    {:noreply, cache, @refresh_interval}
  end

  def handle_info(:timeout, cache) do
    update
    {:noreply, cache}
  end

  # Internal

  defp update do
    GenServer.cast(__MODULE__, :update)
  end

  defp get_data do
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get(api_url)
    JSON.decode!(body)
  end

  defp api_url do
    Enum.join([
     "https://api.forecast.io/forecast/",
      api_key,
      "/",
      @lat,
      ",",
      @lng,
      "?exclude=minutely,hourly,daily,alerts,flags&units=si"
    ], "")
  end

  defp api_key do
    System.get_env("FORECASTIO_API_KEY")
  end

end
