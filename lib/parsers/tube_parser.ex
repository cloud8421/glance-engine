defmodule Glance.TubeParser do

  def parse({_array_of_line_status, [], statuses}) do
    Enum.map(statuses, fn({_linestatus, status_attrs, children}) ->
      extended = status_attrs |> extract_extended
      { name, id } = children |> Enum.at(1) |> extract_name_and_id
      { status, human_status } = children |> Enum.at(2) |> extract_status_and_human_status
      %{
        id: id,
        name: name,
        status: status,
        human_status: human_status,
        extended: extended
      }
    end)
  end

  defp extract_extended([{_status_details, []}, _rest]), do: nil
  defp extract_extended([{_status_details, status_details}, _rest]) do
    status_details |> to_string
  end

  defp extract_name_and_id({_line, [{_name, name}, {_id, id}], []}) do
    { name |> to_string, id |> to_string }
  end

  defp extract_status_and_human_status({_status, status_info, _rest}) do
    { 'CssClass', status }= List.keyfind(status_info, 'CssClass', 0)
    { 'Description', human_status } = List.keyfind(status_info, 'Description', 0)
    { status |> to_string, human_status |> to_string }
  end

end
