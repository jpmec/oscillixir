defmodule Oscillator.Sine.Server do

  use GenServer

  def new(amplitude \\ 1, frequency \\ 1, phase \\ 0) do
    GenServer.start_link(__MODULE__, {amplitude, frequency, phase})
  end

  def get(pid, t) do
    GenServer.call(pid, {:get, t})
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
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

  def handle_call(:inspect, _from, {amplitude, frequency, phase}) do
    {:reply, {:ok, amplitude, frequency, phase}, {amplitude, frequency, phase}}
  end

  def handle_call({:get, t}, _from, {amplitude, frequency, phase}) do
    {:reply, {:ok, Oscillator.Sine.Server.sine(t, amplitude, frequency, phase)}, {amplitude, frequency, phase}}
  end

end
