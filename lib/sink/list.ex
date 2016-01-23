defmodule Sink.List do
  use GenSink, Sink.List

  def new() do
    __MODULE__.start_link([])
  end

  def call({:get}, list) do
    {:lists.reverse(list), list}
  end

  def call({:put, input}, []) do
    {input, [input]}
  end

  def call({:put, input}, tail) do
    {input, [input | tail]}
  end
end
