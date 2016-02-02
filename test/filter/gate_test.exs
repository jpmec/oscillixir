defmodule Filter.GateTest do
  use ExUnit.Case
  doctest Filter.Pid

  test "sine" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, impulse} = Oscillator.Sine.new(100.0)
    {:ok, gate} = Filter.Gate.new(50.0)

    timer
      |> connect(range)
      |> connect(impulse)
      |> connect(gate)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("temp/test/filter/gate_test_sine.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
  end


end
