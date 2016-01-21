defmodule Oscillator.Square do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event({atom, value}, {pid}) do
      Oscillator.Square.set(pid, {atom, value})
      {:ok, {pid}}
    end

    def handle_event(input, {pid}) do
      Oscillator.Square.get(pid, input)
      {:ok, {pid}}
    end
  end

  def new(amplitude \\ 1.0, frequency \\ 440.0, phase \\ 0.0) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{amplitude, frequency, phase}, event_pid})
    {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler}}
  end

  def get(pid, input) do
    GenServer.call(pid, {:get, input})
  end

  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end

  def call(t, {amplitude, frequency, phase}) do
    if 0.0 > :math.sin(:math.pi * 2 * frequency * t + phase) do
      -amplitude
    else
      amplitude
    end
  end

  def handle_call({:get, input}, _from, {state, event_pid}) do
    output = __MODULE__.call(input, state)

    GenEvent.notify(event_pid, output)

    {:reply, output, {state, event_pid}}
  end

  def handle_call({:set, {:a, value}}, _from, {{_, frequency, phase}, event_pid}) do
    {:reply, :ok, {{value, frequency, phase}, event_pid}}
  end

  def handle_call({:set, {:f, value}}, _from, {{amplitude, _, phase}, event_pid}) do
    {:reply, :ok, {{amplitude, value, phase}, event_pid}}
  end

  def handle_call({:set, {:p, value}}, _from, {{amplitude, frequency, _}, event_pid}) do
    {:reply, :ok, {{amplitude, frequency, value}, event_pid}}
  end
end
