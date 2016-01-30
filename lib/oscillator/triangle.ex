defmodule Oscillator.Triangle do

  use GenOscillator, Oscillator.Triangle


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0 / frequency
      end

    __MODULE__.start_link(
      {0.0, bias},
      %Control{
        amplitude: amplitude,
        frequency: frequency,
        phase: phase,
        bias: bias,
        period: period
      }
    )
  end


  def call(t, {x, y}, control) do
    dt = t - x

    if (control.period < dt) do
      x = x + control.period
      dt = t - x
    end

    one_quarter_period = 0.25 * control.period
    three_quarter_period = 0.75 * control.period

    y = cond do
      dt < one_quarter_period ->
        (dt * 4.0 * control.amplitude * control.frequency) + control.bias
      dt < three_quarter_period ->
        dt = dt - one_quarter_period
        control.amplitude - (dt * 4.0 * control.amplitude * control.frequency) + control.bias
      true ->
        dt = dt - three_quarter_period
        -control.amplitude + (dt * 4.0 * control.amplitude * control.frequency) + control.bias
    end

    {{t, y}, {x, y}}
  end

end
