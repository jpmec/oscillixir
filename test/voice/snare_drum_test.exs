defmodule Voice.SnareDrumTest do
  use ExUnit.Case
  doctest Voice.SnareDrum

  test "simple" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, impulse} = Oscillator.Impulse.new(32000.0, 4.0)
    {:ok, snaredrum} = Voice.SnareDrum.new()

    timer
      |> connect(range)
      |> connect(impulse)
      |> connect(snaredrum)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("temp/test/voice/snare_drum_test_simple.pcm", 16))

    Source.Timer.start(timer.server)
    :timer.sleep(2000)
    Source.Timer.stop(timer.server)
    :timer.sleep(2000)
  end

end
