defmodule Glance.Tube do
  use Jazz
  use GenServer
  alias Glance.TubeParser

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
    {:noreply, get_data, @refresh_interval}
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
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get(tube_api_url)
    body |> parse |> TubeParser.parse
  end

  defp tube_api_url do
    "http://cloud.tfl.gov.uk/TrackerNet/LineStatus"
  end

  defp parse(xml) do
    {:ok, parsed, []} = :erlsom.simple_form(xml)
    parsed
  end

end
