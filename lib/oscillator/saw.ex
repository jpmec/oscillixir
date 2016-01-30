defmodule Oscillator.Saw do

  use GenOscillator, Oscillator.Saw


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

    half_period = 0.5 * control.period

    y =
      if (dt < half_period) do
        (dt * 2.0 * control.amplitude * control.frequency) + control.bias
      else
        dt = dt - half_period
        -control.amplitude + (dt * 2.0 * control.amplitude * control.frequency) + control.bias
      end

    {{t, y}, {x, y}}
  end

end
