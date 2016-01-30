defmodule Oscillator.Sine do

  use GenOscillator, Oscillator.Sine


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


  def call(t, {x, y}, control) do
    dt = t - x

    if (control.period < dt) do
     x = x + control.period
     dt = t - x
    end

    y = control.amplitude * :math.sin(:math.pi * 2 * control.frequency * dt + control.phase) + control.bias

    {{t, y}, {x, y}}
  end

end
