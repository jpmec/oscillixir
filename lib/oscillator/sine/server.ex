defmodule Oscillator.Sine.Server do
  use GenServer

  defmodule InputHandler do
    use GenEvent

    def handle_event({:t, t}, {pid}) do
      Oscillator.Sine.Server.get(pid, t)
      {:ok, {pid}}
    end
  end

  def new(amplitude \\ 1, frequency \\ 1, phase \\ 0) do
    {:ok, event_pid} = GenEvent.start_link([])
    GenServer.start_link(__MODULE__, {amplitude, frequency, phase, event_pid})
  end

  def get(pid, t) do
    GenServer.call(pid, {:get, t})
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def event(pid) do
    GenServer.call(pid, :event_pid)
  end

  def sine([t | []], amplitude, frequency, phase) do
    [Oscillator.Sine.Server.sine(t, amplitude, frequency, phase)]
  end

  def sine([t | tail], amplitude, frequency, phase) do
    [Oscillator.Sine.Server.sine(t, amplitude, frequency, phase) | Oscillator.Sine.Server.sine(tail, amplitude, frequency, phase)]
  end

  def sine(t, amplitude, frequency, phase) do
    amplitude * :math.sin(:math.pi * 2 * frequency * t + phase)
  end

  def handle_call(:inspect, _from, {amplitude, frequency, phase, event_pid}) do
    {:reply, {:ok, amplitude, frequency, phase, event_pid}, {amplitude, frequency, phase, event_pid}}
  end

  def handle_call({:get, t}, _from, {amplitude, frequency, phase, event_pid}) do
    y = Oscillator.Sine.Server.sine(t, amplitude, frequency, phase)
    GenEvent.notify(event_pid, {:y, y})
    {:reply, {:ok, y}, {amplitude, frequency, phase, event_pid}}
  end

  def handle_call(:event_pid, _from, {amplitude, frequency, phase, event_pid}) do
    {:reply, {:ok, event_pid}, {amplitude, frequency, phase, event_pid}}
  end
end
