defmodule Filter.Linear do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(t, {pid}) do
      Filter.Linear.get(pid, t)
      {:ok, {pid}}
    end
  end

  def new(gain \\ 1.0, bias \\ 0.0) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{gain, bias}, event_pid})
    {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler}}
  end

  def get(pid, input) do
    GenServer.call(pid, {:get, input})
  end

  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end

  def call(input, {gain, bias}) do
    input * gain + bias
  end

  def handle_call({:get, input}, _from, {state, event_pid}) do
    output = __MODULE__.call(input, state)

    GenEvent.notify(event_pid, output)

    {:reply, output, {state, event_pid}}
  end

  def handle_call({:set, {:g, value}}, _from, {{_, bias}, event_pid}) do
    {:reply, :ok, {{value, bias}, event_pid}}
  end

  def handle_call({:set, {:b, value}}, _from, {{gain, _}, event_pid}) do
    {:reply, :ok, {{gain, value}, event_pid}}
  end
end
