defmodule Oscillator.SquareTest do
  use ExUnit.Case
  doctest Oscillator.Square


  test "simple" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, impulse} = Oscillator.Impulse.new(127.0, 4.0)
    {:ok, adsr} = Envelope.Adsr.new(0.0, 0.02, 0.1, 0.8, 0.05)
    {:ok, square} = Oscillator.Square.new(127.0)

    timer |> connect(range)

    range
      |> connect(impulse)
      |> connect(adsr)
      |> connect(square, :amplitude)

    range
      |> connect(square)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new('adsr_test.pcm'))

    Source.Timer.start(timer.server)

    :timer.sleep(1000)

    Source.Timer.stop(timer.server)

  end

end
