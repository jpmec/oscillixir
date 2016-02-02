defmodule Oscillator.Random.Uniform do

  use GenOscillator, Oscillator.Random.Uniform


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    period =
      if (0.0 == frequency) do
        0.0
      else
        1.0/frequency
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

    if (control.period < dt) do
      x = x + control.period
      y = control.amplitude * (2.0 * :rand.uniform() - 1) + control.bias
    end

    {{t, y}, {x, y}}
  end

end
