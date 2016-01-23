defmodule Oscillixir do

  import Connect

  # A simple example of chaining time source, oscillator, and filters
  def new do

    {:ok, timer} = Source.Timer.new(10)
    {:ok, range} = Sequence.Range.new()

    timer |> connect(range)

    range
      |> connect(Oscillator.Triangle.new(127.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new())
#      |> connect(Sink.Inspect.new())


    # range
    #   |> connect(Oscillator.Sine.new())
    #   |> connect(Filter.Gain.new(127.0))
    #   |> connect(Filter.Round.new())
    #   |> connect(Sink.File.new())


    # range
    #   |> connect(Oscillator.Square.new())
    #   |> connect(Filter.Gain.new(127.0))
    #   |> connect(Filter.Lowpass.new(0.25))
    #   |> connect(Filter.Round.new())
    #   |> connect(Sink.File.new())

    Source.Timer.start(timer.server)

    {:ok}

  end

end
