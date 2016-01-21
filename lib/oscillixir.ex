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

    {:ok, timer} = Source.Timer.new(1000)
    {:ok, range} = Sequence.Range.new(3)
    {:ok, gain} = Filter.Gain.new(0.0)


    timer |> connect(range)

    range
      |> connect(Oscillator.Sine.new())
      |> connect(Filter.Bias.new(0.5))
      |> connect(Filter.Gain.new(10000.0))
      |> connect(gain, :gain)

    range
      |> connect(Oscillator.Square.new())
      |> connect(Filter.Linear.new(0.5, 0.5))
      |> connect(gain)
      |> connect(Filter.Lowpass.new(0.5))
      |> connect(Filter.Gate.new(5.0))
      |> connect(Filter.Limit.new(0.0, 65535.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.Inspect.new())

    Source.Timer.start(timer.server)

    {:ok}

  end

end
