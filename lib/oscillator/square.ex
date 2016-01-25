defmodule Oscillator.Square do

  use GenOscillator, Oscillator.Square

  defmodule AmplitudeHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Oscillator.Square.set(pid, {:amplitude, input})
      {:ok, {pid}}
    end
  end


  defmodule FrequencyHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Oscillator.Square.set(pid, {:frequency, input})
      {:ok, {pid}}
    end
  end


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0 / frequency
      end

    __MODULE__.start_link(
      {amplitude, frequency, phase, bias, period, 0.0, 1 + bias},
      %{
        amplitude: __MODULE__.AmplitudeHandler,
        frequency: __MODULE__.FrequencyHandler
      }
    )
  end


  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end


  def call(t, {amplitude, frequency, phase, bias, period, x, y}) do
    dt = t - x

    if (period < dt) do
      x = x + period
      if 0 < y do
        y = -1
      else
        y = 1
      end
    end

    y = 
      if 0.0 < y do
        amplitude + bias
      else
        -amplitude + bias
    end
        
    {{t, }, {amplitude, frequency, phase, bias, period, x, y}}
  end


  def handle_call({:set, {:amplitude, {t, value}}}, _from, {{_, frequency, phase, bias, period, x, y}, event_pid}) do
    {:reply, :ok, {{value, frequency, phase, bias, period, x, y}, event_pid}}
  end


  def handle_call({:set, {:frequency, {t, value}}}, _from, {{amplitude, _, phase, bias, _, x, y}, event_pid}) do
    new_period =
      if (0.0 == value) do
        0.0
      else
        1.0/value
      end

    {:reply, :ok, {{amplitude, value, phase, bias, new_period, x, y}, event_pid}}
  end

end
