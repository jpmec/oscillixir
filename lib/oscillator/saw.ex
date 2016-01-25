defmodule Oscillator.Saw do

  use GenOscillator, Oscillator.Saw


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0 / frequency
      end

    __MODULE__.start_link {amplitude, frequency, phase, bias, period, 0.0, bias}
  end


  def call(t, {amplitude, frequency, phase, bias, period, x, y}) do
    dt = t - x

    if (period < dt) do
      x = x + period
      dt = t - x
    end

    half_period = 0.5 * period

    y =
      if (dt < half_period) do
        (dt * 2.0 * amplitude * frequency) + bias
      else
        dt = dt - half_period
        -amplitude + (dt * 2.0 * amplitude * frequency) + bias
      end

    {{t, y}, {amplitude, frequency, phase, bias, period, x, y}}
  end

end
