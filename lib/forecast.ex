defmodule Forecast do
  use Jazz

  @lat 51.5199579
  @lng -0.0990549

  def get do
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
