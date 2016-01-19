defmodule Sink.Inspect do
  use GenEvent

  # Callbacks

  def handle_event({:t, t}, []) do
    IO.inspect(t)
    {:ok, []}
  end

  def handle_event({:y, y}, []) do
    IO.inspect(y)
    {:ok, []}
  end
end
