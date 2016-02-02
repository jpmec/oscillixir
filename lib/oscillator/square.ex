defmodule Oscillator.Square do

  use GenOscillator, Oscillator.Square


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0 / frequency
      end

    __MODULE__.start_link(
      {0.0, amplitude + bias},
      %Control{
        amplitude: amplitude,
        frequency: frequency,
        phase: phase,
        bias: bias,
        period: period
      }
    )
  end


  def call({t, _}, state, control) do
    call(t, state, control)
  end


  def call(t, {x, y}, control) do
    dt = t - x

    if control.period < dt do
      x = x + control.period
    end

    half_period = 0.5 * control.period

    y =
      if dt < half_period do
        control.amplitude + control.bias
      else
        -control.amplitude + control.bias
    end

    {{t, y}, {x, y}}
  end

end
