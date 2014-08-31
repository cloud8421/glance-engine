defmodule Glance.Weekend do
  use GenServer
  alias Glance.WeekendParser

  @refresh_interval 60000

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
    new_data = get_data
    GenEvent.notify(:event_dispatcher, {:updated, :weekend})
    {:noreply, new_data, @refresh_interval}
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
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get(api_url)
    body |> parse |> WeekendParser.parse
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
