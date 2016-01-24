defmodule Sequence.Range do
  use GenSequence, Sequence.Range


  def new(length \\ 441, increment \\ 0.000022675736961451248, at \\ 0.0) do
    __MODULE__.start_link {at, length, increment}
  end


  def call({at, length, increment}) do
    output = for i <- 0..length-1, do: at + i*increment
    at = List.last(output) + increment

    {output, {at, length, increment}}
  end

end
