defmodule Sink.Inspect do
  use GenEvent

  def handle_event(input, []) do
    IO.inspect(input)
    {:ok, []}
  end
end
