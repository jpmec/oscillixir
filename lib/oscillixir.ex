defmodule Oscillixir do

  import Connect

  # A simple example of chaining time source, oscillator, and filters
  def new do

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square} = Oscillator.Square.new(127.0)
    {:ok, sine} = Oscillator.Sine.new(110.0, 1.0, 0.0, 330.0)

    timer |> connect(range)

    range
      |> connect(sine)
      |> connect(square, :frequency)

    range
      |> connect(square)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new())


    Source.Timer.start(timer.server)

    # range
    #   |> connect(sine)


 #   range |> connect(Sink.Inspect.new())


    # range
    #   |> connect(Oscillator.Triangle.new(127.0))
    #   |> connect(Filter.Round.new())
    #   |> connect(Sink.Inspect.new())

#      |> connect(Sink.File.new())


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

    #Source.Timer.start(timer.server)

    {:ok}

  end

end
