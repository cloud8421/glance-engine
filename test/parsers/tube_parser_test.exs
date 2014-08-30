defmodule TubeParserTest do
  use ExUnit.Case

  alias Glance.TubeParser

  @sample_response {'ArrayOfLineStatus', [],
   [{'LineStatus',
     [{'StatusDetails', []}, {'ID', '0'}],
     [{'BranchDisruptions', [], []},
      {'Line', [{'Name', 'Bakerloo'}, {'ID', '1'}],
       []},
      {'Status',
       [{'IsActive', 'true'}, {'Description', 'Good Service'},
        {'CssClass', 'GoodService'}, {'ID', 'GS'}],
       [{'StatusType',
         [{'Description', 'Line'}, {'ID', '1'}], []}]}]},
    {'LineStatus',
       [{'StatusDetails',
         'No service between Clapham Junction to Kensington (Olympia) due to planned engineering work. GOOD SERVICE all other routes.'},
        {'ID', '82'}],
       [{'BranchDisruptions', [],
         [{'BranchDisruption', [],
           [{'StationTo',
             [{'Name', 'Kensington (Olympia)'}, {'ID', '122'}], []},
            {'StationFrom',
             [{'Name', 'Clapham Junction'}, {'ID', '302'}], []},
            {'Status',
             [{'IsActive', 'true'}, {'Description', 'Part Closure'},
              {'CssClass', 'DisruptedService'}, {'ID', 'PC'}],
             [{'StatusType',
               [{'Description', 'Line'}, {'ID', '1'}], []}]}]}]},
        {'Line',
         [{'Name', 'Overground'}, {'ID', '82'}], []},
        {'Status',
         [{'IsActive', 'true'}, {'Description', 'Part Closure'},
          {'CssClass', 'DisruptedService'}, {'ID', 'PC'}],
         [{'StatusType',
           [{'Description', 'Line'}, {'ID', '1'}], []}]}]}]}

  test "it parses into the expected structure" do
    expected = [
      %{
        id: "1",
        name: "Bakerloo",
        status: "GoodService",
        human_status: "Good Service",
        extended: nil
      },
      %{
        id: "82",
        name: "Overground",
        status: "DisruptedService",
        human_status: "Part Closure",
        extended: "No service between Clapham Junction to Kensington (Olympia) due to planned engineering work. GOOD SERVICE all other routes."
      }
    ]
    assert TubeParser.parse(@sample_response) == expected
  end

end
