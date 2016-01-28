defmodule Mixer.SumTest do
  use ExUnit.Case
  doctest Mixer.Sum


  test "simple" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square0} = Oscillator.Square.new(40.0, 330.0)
    {:ok, square1} = Oscillator.Square.new(80.0, 550.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)
    range |> connect(square0)
    range |> connect(square1)

    square0 |> connect(sum)
    square1 |> connect(sum)

    sum
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_simple.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
  end

end
