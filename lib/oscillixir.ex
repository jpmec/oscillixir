defmodule Oscillixir do

  import Connect

  # A simple example of chaining time source, oscillator, and filters
  def new do

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()

    {:ok, saw} = Oscillator.Saw.new(127.0)
    {:ok, square} = Oscillator.Square.new(127.0)
    {:ok, triangle} = Oscillator.Triangle.new(127.0)

    {:ok, frequency_sine} = Oscillator.Sine.new(41.25, 1.0, 0.0, 68.75)
    {:ok, amplitude_sine} = Oscillator.Sine.new(63.5, 2.0, 0.0, 63.5)


    timer |> connect(range)

    range
      |> connect(frequency_sine)
      |> connect(triangle, :frequency)

    range
      |> connect(amplitude_sine)
      |> connect(triangle, :amplitude)

    range
      |> connect(triangle)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new())


    # range
    #   |> connect(square)
    #   |> connect(Filter.Round.new())
    #   |> connect(Sink.File.new())


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
