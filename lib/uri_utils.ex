defmodule UriUtils do

  def list_to_query_string(params) do
    Enum.map(params, fn({name, value}) ->
      "#{name}=#{value}"
    end)
    |> Enum.join("&")
  end

end
