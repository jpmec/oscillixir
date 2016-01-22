defmodule Oscillator.Saw do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(t, {pid}) do
      Oscillator.Saw.get(pid, t)
      {:ok, {pid}}
    end
  end

  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0, bias \\ 0.0) do

    period = 1.0/frequency
    state = {amplitude, frequency, phase, bias, period, phase + period/2.0}

    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {state, event_pid})
    {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler}}
  end

  def get(pid, t) do
    GenServer.call(pid, {:get, t})
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

  def handle_call({:get, input}, _from, {state, event_pid}) do
    {output, new_state} = __MODULE__.call(input, state)

    GenEvent.notify(event_pid, output)

    {:reply, output, {new_state, event_pid}}
  end
end
