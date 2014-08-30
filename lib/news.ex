defmodule News do
  use Jazz
  use GenServer

  @refresh_interval 300_000

  # Public API

  def get(country) when country in [:uk, :italy] do
    GenServer.call(__MODULE__, {:get, country})
  end

  # GenServer Callbacks

  def start_link do
    initial = %{uk: nil, italy: nil}
    {:ok, cache} = Agent.start_link(fn() -> initial end)
    GenServer.start_link(__MODULE__, cache, name: __MODULE__)
  end

  def init(cache) do
    {:ok, cache, 0}
  end

  def handle_call({:get, country}, _From, cache) do
    country_news = Agent.get(cache, fn(news) ->
      Map.get(news, country)
    end)
    {:reply, country_news, cache}
  end

  def handle_cast({:update, country}, cache) do
    country_data = get_data(country)
    Agent.get_and_update(cache, fn(news) ->
      {:ok, Map.put(news, country, country_data)}
    end)
    {:noreply, cache, @refresh_interval}
  end

  def handle_info(:timeout, cache) do
    update
    {:noreply, cache}
  end

  # Internal

  defp update do
    GenServer.cast(__MODULE__, {:update, :italy})
    GenServer.cast(__MODULE__, {:update, :uk})
  end

  defp get_data(country) do
    %HTTPoison.Response{status_code: 200, body: body} = api_url(country)
    |> HTTPoison.get
    JSON.decode!(body)
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
    "#{base_url}?#{params |> params_to_query_string}"
  end

  defp base_url do
    "http://beta.content.guardianapis.com/search"
  end

  defp api_key do
    System.get_env("GUARDIAN_API_KEY")
  end

  defp params_to_query_string(params) do
    Enum.map(params, fn({name, value}) ->
      "#{name}=#{value}"
    end)
    |> Enum.join("&")
  end
end
