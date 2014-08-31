defmodule Glance.NewsParser do

  def parse(news_data) do
    news_data["response"]["results"]
  end

end
