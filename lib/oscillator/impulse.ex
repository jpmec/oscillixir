defmodule Oscillator.Impulse do

  use GenOscillator, Oscillator.Impulse


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0 / frequency
      end

    __MODULE__.start_link(
      {0.0, 0.0},
      %Control{
        amplitude: amplitude,
        frequency: frequency,
        phase: phase,
        bias: bias,
        period: period
      }
    )
  end


  def call(t, {x, _}, control) do
    dt = t - x

    y =
      cond do
        dt == 0 ->
          control.amplitude + control.bias
        control.period < dt ->
          x = x + control.period
          control.amplitude + control.bias
        true->
          control.bias
      end

    {{t, y}, {x, y}}
  end

end
