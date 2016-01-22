defmodule Oscillator.Square do

  use GenOscillator, Oscillator.Square

  # defmodule AmplitudeHandler do
  #   use GenEvent

  #   def handle_event(input, {pid}) do
  #     Oscillator.Square.set(pid, {:amplitude, input})
  #     {:ok, {pid}}
  #   end
  # end


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    __MODULE__.init {amplitude, frequency, phase, bias}
  end


  # def set(pid, input) do
  #   GenServer.call(pid, {:set, input})
  # end


  def call(t, {amplitude, frequency, phase, bias}) do
    if 0.0 > :math.sin(:math.pi * 2 * frequency * t + phase) do
      y = -amplitude + bias
      {y, {amplitude, frequency, phase, bias}}
    else
      y = amplitude + bias
      {y, {amplitude, frequency, phase, bias}}
    end
  end


  # def handle_call({:set, {:amplitude, value}}, _from, {{_, frequency, phase, bias}, event_pid}) do
  #   {:reply, :ok, {{value, frequency, phase, bias}, event_pid}}
  # end

  # def handle_call({:set, {:f, value}}, _from, {{amplitude, _, phase, bias}, event_pid}) do
  #   {:reply, :ok, {{amplitude, value, phase, bias}, event_pid}}
  # end

  # def handle_call({:set, {:p, value}}, _from, {{amplitude, frequency, _, bias}, event_pid}) do
  #   {:reply, :ok, {{amplitude, frequency, value, bias}, event_pid}}
  # end

  # def handle_call({:set, {:b, value}}, _from, {{amplitude, frequency, phase, _}, event_pid}) do
  #   {:reply, :ok, {{amplitude, frequency, phase, value}, event_pid}}
  # end

end
