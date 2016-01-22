defmodule Oscillixir do

  def connect({:ok, from}, to) do
    :ok = GenEvent.add_handler(from.event, {to.input, to.server}, {to.server})
    to
  end

  def connect(from, {:ok, to}) do
    :ok = GenEvent.add_handler(from.event, {to.input, to.server}, {to.server})
    to
  end

  def connect(from, to) do
    :ok = GenEvent.add_handler(from.event, {to.input, to.server}, {to.server})
    to
  end

  def connect(from, to, parameter) do
    :ok = GenEvent.add_handler(from.event, {Map.get(to, parameter), to.server}, {to.server})
    to
  end


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
