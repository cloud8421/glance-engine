defmodule WeekendParserTest do
  use ExUnit.Case

  alias Glance.WeekendParser

  @sample_response {'SyndicatedFeed',
     [{'version', '200102231620'},
      {'{http://www.w3.org/2001/XMLSchema-instance}noNamespaceSchemaLocation',
       'http://www.tfl.gov.uk/tfl/syndication/feeds/xsd/SyndicatedFeedTrack.xsd'}],
     [{'Header', [],
       [{'Identifier', [], ['TfL | Service update - weekend - tube']},
        {'DisplayTitle', [], ['TfL | Service update - weekend - tube']},
        {'Version', [], ['200102231620']},
        {'PublishDateTime', [{'utc', '31/08/2014 07:25:34'}],
         ['Sun, 31 Aug 2014 08:25:34 +01:00']},
        {'Author', [], ['webteam@tfl.gov.uk']},
        {'Owner', [], ['Transport for London']}, {'RefreshRate', [], ['1']},
        {'Max_Latency', [], ['2']}, {'TimeToError', [], ['2']},
        {'OverrideMessage', [], []}, {'ErrorMessage', [], []},
        {'FeedInfo', [],
         ['Developer information regarding the current state of the feed. Not to be displayed.']},
        {'Attribution', [],
         [{'Url', [], ['http://www.tfl.gov.uk']}, {'Text', [], ['copyright TfL']},
          {'Logo', [], ['http://www.tfl.gov.uk/tfl-global/images/roundel.gif']}]},
        {'Language', [], ['en']}]},
      {'Lines', [],
       [{'Line', [],
         [{'Name', [], ['Bakerloo']}, {'Colour', [], ['FFF']},
          {'BgColour', [], ['AE6118']},
          {'Url', [],
           ['http://www.tfl.gov.uk/tfl/livetravelnews/realtime/tube/default.html']},
          {'Status', [],
           [{'Text', [], ['Good Service']}, {'Colour', [], ['000000']},
            {'BgColour', [], ['FFF']}]}]},
        {'Line', [],
         [{'Name', [], ['Central']}, {'Colour', [], ['FFF']},
          {'BgColour', [], ['E41F1F']},
          {'Url', [],
           ['http://www.tfl.gov.uk/tfl/livetravelnews/realtime/tube/default.html']},
          {'Status', [],
           [{'Text', [], ['Good Service']}, {'Colour', [], ['000000']},
            {'BgColour', [], ['FFF']}]}]}]}]}

  test "it parses into the expected structure" do
    expected = [
      %{
        name: "Bakerloo",
        color: "AE6118",
        status: "Good Service"
      },
      %{
        name: "Central",
        color: "E41F1F",
        status: "Good Service"
      }
    ]
    assert WeekendParser.parse(@sample_response) == expected
  end

end
