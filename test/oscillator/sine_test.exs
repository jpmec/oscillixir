defmodule Oscillator.SineTest do
  use ExUnit.Case
  doctest Oscillator.Sine

  test "true is true" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, sine} = Oscillator.Sine.new()
    {:ok, sink} = Sink.List.new()

    timer |> connect(range) |> connect(sine) |> connect(sink)

    Source.Timer.tick(timer.server)

    :timer.sleep(1000)

    list = Sink.List.get(sink.server)

    assert 0.0 == Enum.at(list, 0)

    IO.inspect(list)
  end

end
