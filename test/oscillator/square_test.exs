defmodule Oscillator.SquareTest do
  use ExUnit.Case
  doctest Oscillator.Square

  test "1 tick" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new(10)
    {:ok, square} = Oscillator.Square.new()
    {:ok, sink} = Sink.List.new()

    timer |> connect(range) |> connect(square) |> connect(sink)

    Source.Timer.tick(timer.server)

    :timer.sleep(1000)

    list = Sink.List.get(sink.server)

    assert 1.0 == Enum.at(list, 0)

    IO.inspect(list)
  end

end
