defmodule Oscillator.Saw do

  use GenOscillator, Oscillator.Saw


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0/frequency
      end

    __MODULE__.start_link {amplitude, frequency, phase, bias, period, phase + period/2.0}
  end


  def call(input, {amplitude, frequency, phase, bias, period, x}) do
    t = input - x

    if (t >= period) do
      x = x + period
      t = input - x
    end

    y = -amplitude + (t * 2.0 * amplitude * frequency) + bias

    {y, {amplitude, frequency, phase, bias, period, x}}
  end

end
