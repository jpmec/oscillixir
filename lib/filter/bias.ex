defmodule Filter.Bias do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Filter.Bias.get(pid, input)
      {:ok, {pid}}
    end
  end

  def new(bias \\ 0.0) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{bias}, event_pid})
    {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler}}
  end

  def get(pid, input) do
    GenServer.call(pid, {:get, input})
  end

  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end

  def call(input, {bias}) do
    input + bias
  end

  def handle_call(:inspect, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:get, input}, _from, {state, event_pid}) do
    output = __MODULE__.call(input, state)

    GenEvent.notify(event_pid, output)

    {:reply, output, {state, event_pid}}
  end

  def handle_call({:set, {:g, value}}, _from, {{_}, event_pid}) do
    {:reply, :ok, {{value}, event_pid}}
  end
end
