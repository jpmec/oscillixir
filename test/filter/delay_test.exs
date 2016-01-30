defmodule Mixer.DelayTest do
  use ExUnit.Case
  doctest Filter.Delay


  test "simple" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, impulse} = Oscillator.Impulse.new(40.0, 10.0)
    {:ok, delay} = Filter.Delay.new(0.05)

    timer
      |> connect(range)
      |> connect(impulse)
      |> connect(delay)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("delay_test_simple.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
  end

end
