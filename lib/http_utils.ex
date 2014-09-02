defmodule Glance.HttpUtils do

  def ttl_for(expiry_date, now) do
    {:ok, date} = Timex.DateFormat.parse(expiry_date, "{RFC1123}")
    utc_date = Timex.Date.universal(date)
    1000 * (Timex.Date.to_secs(utc_date) - Timex.Date.to_secs(now))
  end

end
