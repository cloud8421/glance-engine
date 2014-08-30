defmodule Glance.Weekend do
  use GenServer

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
    body |> parse
  end

  def api_url do
    params = [
      {"app_id", app_id},
      {"app_key", api_key}
    ]
    "#{base_url}?#{params |> UriUtils.list_to_query_string}"
  end

  defp base_url do
    "http://data.tfl.gov.uk/tfl/syndication/feeds/TubeThisWeekend_v2.xml"
  end

  defp api_key do
    System.get_env("TFL_API_KEY")
  end

  defp app_id do
    System.get_env("WEEKEND_APP_ID")
  end

  defp parse(xml) do
    {:ok, parsed, []} = :erlsom.simple_form(xml)
    parsed
  end

end
