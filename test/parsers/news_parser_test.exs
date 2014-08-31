defmodule NewsParserTest do
  use ExUnit.Case
  alias Glance.NewsParser

  @sample_response %{"response" => %{"currentPage" => 1, "orderBy" => "newest", "pageSize" => 10,
    "pages" => 599,
    "results" => [%{"apiUrl" => "http://beta.content.guardianapis.com/global/2014/aug/30/portrait-federica-mogherini-eu-foreign-policy-chief",
       "id" => "global/2014/aug/30/portrait-federica-mogherini-eu-foreign-policy-chief",
       "sectionId" => "global", "sectionName" => "Global",
       "webPublicationDate" => "2014-08-30T18:46:24Z",
       "webTitle" => "A portrait of Federica Mogherini, the EU's next foreign policy chief",
       "webUrl" => "http://www.theguardian.com/global/2014/aug/30/portrait-federica-mogherini-eu-foreign-policy-chief"},
     %{"apiUrl" => "http://beta.content.guardianapis.com/world/video/2014/aug/30/african-migrants-rescued-italian-coastguard-video",
       "id" => "world/video/2014/aug/30/african-migrants-rescued-italian-coastguard-video",
       "sectionId" => "world", "sectionName" => "World news",
       "webPublicationDate" => "2014-08-30T15:27:17Z",
       "webTitle" => "African migrants travelling by boat rescued by the Italian coastguard - video",
       "webUrl" => "http://www.theguardian.com/world/video/2014/aug/30/african-migrants-rescued-italian-coastguard-video"}]}}

  test "it parses into the expected structure" do
    expected = [%{"apiUrl" => "http://beta.content.guardianapis.com/global/2014/aug/30/portrait-federica-mogherini-eu-foreign-policy-chief",
       "id" => "global/2014/aug/30/portrait-federica-mogherini-eu-foreign-policy-chief",
       "sectionId" => "global", "sectionName" => "Global",
       "webPublicationDate" => "2014-08-30T18:46:24Z",
       "webTitle" => "A portrait of Federica Mogherini, the EU's next foreign policy chief",
       "webUrl" => "http://www.theguardian.com/global/2014/aug/30/portrait-federica-mogherini-eu-foreign-policy-chief"},
     %{"apiUrl" => "http://beta.content.guardianapis.com/world/video/2014/aug/30/african-migrants-rescued-italian-coastguard-video",
       "id" => "world/video/2014/aug/30/african-migrants-rescued-italian-coastguard-video",
       "sectionId" => "world", "sectionName" => "World news",
       "webPublicationDate" => "2014-08-30T15:27:17Z",
       "webTitle" => "African migrants travelling by boat rescued by the Italian coastguard - video",
       "webUrl" => "http://www.theguardian.com/world/video/2014/aug/30/african-migrants-rescued-italian-coastguard-video"}]
    assert NewsParser.parse(@sample_response) == expected
  end

end
