defmodule Oscillixir do

  import Connect

  # A simple example of chaining time source, oscillator, and filters
  def new do

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()


    {:ok, sine} = Oscillator.Sine.new(127.0)
    {:ok, saw} = Oscillator.Saw.new(127.0)
    {:ok, square} = Oscillator.Square.new(127.0)
    {:ok, triangle} = Oscillator.Triangle.new(127.0)
    {:ok, random_uniform} = Oscillator.Random.Uniform.new(127.0)
    {:ok, random_normal} = Oscillator.Random.Normal.new(127.0)

    {:ok, random_sample} = Oscillator.Random.Sample.new([110.0, 220.0, 440.0], 1.0, 16.0)

    {:ok, frequency_sine} = Oscillator.Sine.new(110.0, 1.0, 0.0, 330.0)
    {:ok, amplitude_sine} = Oscillator.Sine.new(63.5, 2.0, 0.0, 63.5)


    timer |> connect(range)

    # range
    #   |> connect(random_sample)
    #   |> connect(square, :frequency)


    range
      |> connect(frequency_sine)
      |> connect(sine, :frequency)

    # range
    #   |> connect(amplitude_sine)
    #   |> connect(sine, :amplitude)

    range
      |> connect(sine)
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
