defmodule Oscillator.Sine do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(t, {pid}) do
      Oscillator.Sine.get(pid, t)
      {:ok, {pid}}
    end
  end

  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{amplitude, frequency, phase}, event_pid})
    {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler}}
  end

  def get(pid, t) do
    GenServer.call(pid, {:get, t})
  end

  def call(input, {amplitude, frequency, phase}) do
    amplitude * :math.sin(:math.pi * 2 * frequency * input + phase)
  end

  def handle_call({:get, input}, _from, {state, event_pid}) do
    output = __MODULE__.call(input, state)

    GenEvent.notify(event_pid, output)

    {:reply, output, {state, event_pid}}
  end
end
