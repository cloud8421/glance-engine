defmodule News do
  use Jazz

  def get(country) do
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
