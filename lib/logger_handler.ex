defmodule Glance.LoggerHandler do
  use GenEvent
  require Logger

  def handle_event({:updated, type}, state) do
    Logger.debug("updated #{type}")
    {:ok, state}
  end

end
