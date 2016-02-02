defmodule Oscillator.ImpulseTest do
  use ExUnit.Case
  doctest Oscillator.Impulse


  test "simple" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, impulse} = Oscillator.Impulse.new(127.0, 4.0)

    timer
      |> connect(range)
      |> connect(impulse)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("temp/test/oscillator/impulse_test_simple.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end

end
