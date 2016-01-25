defmodule Oscillator.Triangle do

  use GenOscillator, Oscillator.Triangle


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

    one_quarter_period = 0.25 * period
    three_quarter_period = 0.75 * period

    y = cond do
      dt < one_quarter_period ->
        (dt * 4.0 * amplitude * frequency) + bias
      dt < three_quarter_period ->
        dt = dt - one_quarter_period
        amplitude - (dt * 4.0 * amplitude * frequency) + bias
      true ->
        dt = dt - three_quarter_period
        -amplitude + (dt * 4.0 * amplitude * frequency) + bias
    end

    {{t, y}, {amplitude, frequency, phase, bias, period, x, y}}
  end

end
