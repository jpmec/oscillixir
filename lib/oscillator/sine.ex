defmodule Oscillator.Sine do

  use GenOscillator, Oscillator.Sine


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

    y = amplitude * :math.sin(:math.pi * 2 * frequency * dt + phase) + bias

    {{t, y}, {amplitude, frequency, phase, bias, period, x, y}}
  end

end
