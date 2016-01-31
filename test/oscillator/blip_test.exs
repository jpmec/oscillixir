defmodule Oscillator.BlipTest do
  use ExUnit.Case
  doctest Oscillator.Blip


  test "simple" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, blip} = Oscillator.Blip.new(127.0)

    timer
      |> connect(range)
      |> connect(blip)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("temp/test/oscillator/blip_test_simple.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end

end
