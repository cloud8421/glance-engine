defmodule Glance.News do
  use Jazz
  use GenServer
  alias Glance.NewsParser

  @refresh_interval 300_000
  @allowed_server_ids [:news_uk, :news_italy]

  # Public API

  def get(server_id) do
    GenServer.call(server_id, :get)
  end

  # GenServer Callbacks

  def start_link(server_id) when server_id in @allowed_server_ids do
    GenServer.start_link(__MODULE__, server_id, name: server_id)
  end

  def init(server_id) do
    initial_state = %{
      server_id: server_id,
      data: nil
    }
    {:ok, initial_state, 0}
  end

  def handle_call(:get, _From, state) do
    {:reply, state.data, state}
  end

  def handle_cast(:update, state) do
    data = get_data(state.server_id |> country_for)
    new_state = Map.put(state, :data, data)
    GenEvent.notify(:event_dispatcher, {:updated, state.server_id})
    {:noreply, new_state, @refresh_interval}
  end

  def handle_info(:timeout, state) do
    update(state.server_id)
    {:noreply, state}
  end

  # Internal

  defp country_for(:news_uk), do: :uk
  defp country_for(:news_italy), do: :italy

  defp update(server_id) do
    GenServer.cast(server_id, :update)
  end

  defp get_data(country) do
    %HTTPoison.Response{status_code: 200, body: body} = api_url(country)
    |> HTTPoison.get
    JSON.decode!(body) |> NewsParser.parse
  end

  defp api_url(:uk) do
    params = [
      {"section", "uk-news"},
      {"api-key", api_key}
    ]
    do_api_url(params)
  end

  defp api_url(:italy) do
    params = [
      {"tag", "world/italy"},
      {"api-key", api_key}
    ]
    do_api_url(params)
  end

  defp do_api_url(params) do
    "#{base_url}?#{params |> UriUtils.list_to_query_string}"
  end

  defp base_url do
    "http://beta.content.guardianapis.com/search"
  end

  defp api_key do
    System.get_env("GUARDIAN_API_KEY")
  end

end
