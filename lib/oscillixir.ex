defmodule Oscillixir do

  # A simple example of chaining time source, oscillator, and filters
  def new do

    {:ok, time_pid} = Sequence.Time.Server.new(1000)
    {:ok, time_event_pid} = Sequence.Time.Server.event(time_pid)

    {:ok, sine_pid} = Oscillator.Sine.Server.new(1, 0.1, 0)
    {:ok, sine_event_pid} = Oscillator.Sine.Server.event(sine_pid)

    {:ok, lowpass_pid} = Filter.Lowpass.Server.new(0.4)
    {:ok, lowpass_event_pid} = Filter.Lowpass.Server.event(lowpass_pid)

    GenEvent.add_handler(time_event_pid, Oscillator.Sine.Server.InputHandler, {sine_pid})
    GenEvent.add_handler(sine_event_pid, Filter.Lowpass.Server.InputHandler, {lowpass_pid})
    GenEvent.add_handler(lowpass_event_pid, Sink.Inspect, [])

    Sequence.Time.Server.start(time_pid)

    {:ok, time_pid}

  end

end
