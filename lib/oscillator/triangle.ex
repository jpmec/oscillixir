defmodule Oscillator.Triangle do

  use GenOscillator, Oscillator.Triangle


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    period = 1.0/frequency

    __MODULE__.init {amplitude, frequency, phase, bias, period, phase}
  end


  def call(input, {amplitude, frequency, phase, bias, period, x}) do
    t = input - x

    if (t >= period) do
      x = x + period
      t = input - x
    end

    half_period = period / 2.0

    if (t < half_period) do
      y = -amplitude + (t * 4.0 * amplitude * frequency) + bias
      {y, {amplitude, frequency, phase, bias, period, x}}
    else
      t = t - half_period
      y = amplitude - (t * 4.0 * amplitude * frequency) + bias
      {y, {amplitude, frequency, phase, bias, period, x}}
    end
  end

end
