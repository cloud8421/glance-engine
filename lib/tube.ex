defmodule Glance.Tube do
  use Jazz
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
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get(tube_api_url)
    body |> parse
  end

  defp tube_api_url do
    "http://cloud.tfl.gov.uk/TrackerNet/LineStatus"
  end

  defp parse(xml) do
    {:ok, parsed, []} = :erlsom.simple_form(xml)
    parsed
  end

end
