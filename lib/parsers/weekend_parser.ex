defmodule Glance.WeekendParser do

  def parse({_feed, _attrs, children}) do
    {_line, _attrs, lines} = List.keyfind(children, 'Lines', 0)
    Enum.map(lines, &extract_line_info/1)
  end

  defp extract_line_info({_line, _attrs, line_info}) do
    {_name_key, _attrs, name} = List.keyfind(line_info, 'Name', 0)
    {_color_key, _attrs, color} = List.keyfind(line_info, 'BgColour', 0)
    {_status_key, _attrs, status_info} = List.keyfind(line_info, 'Status', 0)
    {_status_info, _attrs_, [status_text]} = List.keyfind(status_info, 'Text', 0)
    %{
      name: name |> to_string,
      color: color |> to_string,
      status: status_text |> to_string
    }
  end

end
