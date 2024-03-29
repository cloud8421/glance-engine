defmodule Glance.Forecast do
  use Jazz
  use GenServer

  @lat 51.5199579
  @lng -0.0990549
  @refresh_interval 60_000

  # Public API

  def get do
    GenServer.call(__MODULE__, :get)
  end

  # GenServer Callbacks

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(data) do
    {:ok, data, 0}
  end

  def handle_call(:get, _from, data) do
    {:reply, data, data}
  end

  def handle_cast(:update, _data) do
    {expiry, new_data} = get_data
    GenEvent.notify(:event_dispatcher, {:updated, :forecast})
    {:noreply, new_data, expiry}
  end

  def handle_info(:timeout, data) do
    update
    {:noreply, data}
  end

  # Internal

  defp update do
    GenServer.cast(__MODULE__, :update)
  end

  defp get_data do
    %HTTPoison.Response{status_code: 200, body: body, headers: headers} = HTTPoison.get(api_url)
    ttl = calculate_expiry(headers["Expires"])
    {ttl, JSON.decode!(body)}
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

  defp calculate_expiry(nil), do: @refresh_interval
  defp calculate_expiry(expires_header) do
    Glance.HttpUtils.ttl_for(expires_header, Timex.Date.now)
  end

end
