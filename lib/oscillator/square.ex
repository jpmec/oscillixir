defmodule Oscillator.Square do

  use GenOscillator, Oscillator.Square


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0 / frequency
      end

    __MODULE__.start_link {amplitude, frequency, phase, bias, period, 0.0, 1 + bias}
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

end
