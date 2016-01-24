defmodule Oscillator.Random.Sample do

  use GenOscillator, Oscillator.Random.Sample


  defmodule AmplitudeHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Oscillator.Random.Sample.set(pid, {:amplitude, input})
      {:ok, {pid}}
    end
  end


  defmodule FrequencyHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Oscillator.Random.Sample.set(pid, {:frequency, input})
      {:ok, {pid}}
    end
  end


  def new(from, amplitude \\ 1.0, frequency \\ 1.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0/frequency
      end

      sample = Enum.random(from)
      y = amplitude * sample + bias

    __MODULE__.start_link(
      {from, amplitude, frequency, phase, bias, period, 0.0, y},
      %{
        amplitude: __MODULE__.AmplitudeHandler,
        frequency: __MODULE__.FrequencyHandler
      }
    )
  end


  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end


  def call(t, {from, amplitude, frequency, phase, bias, period, x, y}) do

    dt = t - x

    if (period < dt) do
      x = x + period
      sample = Enum.random(from)
      y = amplitude * sample + bias
    end

    {{t, y}, {from, amplitude, frequency, phase, bias, period, x, y}}
  end


  def handle_call({:set, {:amplitude, value}}, _from, {{from, _, frequency, phase, bias, period, x, y}, event_pid}) do
    {:reply, :ok, {{from, value, frequency, phase, bias, period, x, y}, event_pid}}
  end


  def handle_call({:set, {:frequency, value}}, _from, {{from, amplitude, _, phase, bias, _, x, y}, event_pid}) do
    new_period =
      if (0.0 == value) do
        0.0
      else
        1.0/value
      end

    {:reply, :ok, {{from, amplitude, value, phase, bias, new_period, x, y}, event_pid}}
  end

end
