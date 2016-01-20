defmodule Oscillixir do

  def connect(from, to) do
    GenEvent.add_handler(from.event, to.input, {to.server})
  end

  # A simple example of chaining time source, oscillator, and filters
  def new do

    {:ok, timer} = Sequence.Timer.Server.new(1000)
    {:ok, range} = Sequence.Range.Server.new()
#    {:ok, square_pid, range_event_pid} = Oscillator.Square.Server.new(1, 0.1, 0)


    timer |> connect(range)

#    GenEvent.add_handler(timer.event, Sequence.Range.Server.InputHandler, {range.server})

    # {:ok, square_event_pid} = Oscillator.Square.Server.event(square_pid)

    # {:ok, sine_pid} = Oscillator.Sine.Server.new(1, 0.1, 0)
    # {:ok, sine_event_pid} = Oscillator.Sine.Server.event(sine_pid)

    # {:ok, lowpass_pid} = Filter.Lowpass.Server.new(0.4)
    # {:ok, lowpass_event_pid} = Filter.Lowpass.Server.event(lowpass_pid)

    # GenEvent.add_handler(time_event_pid, Oscillator.Sine.Server.InputHandler, {sine_pid})

    # GenEvent.add_handler(sine_event_pid, Filter.Lowpass.Server.InputHandler, {lowpass_pid})

    GenEvent.add_handler(range.event, Sink.Inspect, [])

    Sequence.Timer.Server.start(timer.server)

    {:ok}

  end

end
