defmodule Oscillator.Sine do

  use GenOscillator, Oscillator.Sine


  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do
    __MODULE__.init {amplitude, frequency, phase, bias}
  end


  def call(input, {amplitude, frequency, phase, bias}) do
    y = amplitude * :math.sin(:math.pi * 2 * frequency * input + phase) + bias

    {y, {amplitude, frequency, phase, bias}}
  end

end
