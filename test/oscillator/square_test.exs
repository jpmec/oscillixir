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

    :timer.sleep(100)

    list = Sink.List.get(sink.server)

    assert 10 == Enum.count(list)
    assert {0.0, 1.0} == Enum.at(list, 0)

    IO.inspect(list)
  end




  test "1 tick" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square} = Oscillator.Square.new(127.0)
    {:ok, frequency_sine} = Oscillator.Sine.new(41.25, 1.0, 0.0, 68.75)
    {:ok, amplitude_sine} = Oscillator.Sine.new(63.5, 2.0, 0.0, 63.5)

    timer |> connect(range)

    range
      |> connect(frequency_sine)
      |> connect(square, :frequency)

    range
      |> connect(amplitude_sine)
      |> connect(square, :amplitude)

    range
      |> connect(square)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new())

    Source.Timer.tick(timer.server)

    :timer.sleep(100)

    list = Sink.List.get(sink.server)

    assert 10 == Enum.count(list)
    assert {0.0, 1.0} == Enum.at(list, 0)

    IO.inspect(list)
  end

end
