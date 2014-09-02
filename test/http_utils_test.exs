defmodule HttpUtilsTest do
  use ExUnit.Case

  alias Glance.HttpUtils

  test "it calculates the right expiry" do
    expiry_date = "Sun, 31 Aug 2014 15:45:34 GMT"
    datetime = {{2014,8,31},{15,44,34}}
    now = Timex.Date.from(datetime)
    assert HttpUtils.ttl_for(expiry_date, now) == 60_000
  end
end
