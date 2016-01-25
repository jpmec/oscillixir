defmodule Oscillator.Random.Sample do

  use GenOscillator, Oscillator.Random.Sample


  def new(from, amplitude \\ 1.0, frequency \\ 1.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0/frequency
      end

      sample = Enum.random(from)
      y = amplitude * sample + bias

    __MODULE__.start_link {from, amplitude, frequency, phase, bias, period, 0.0, y}
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

end
