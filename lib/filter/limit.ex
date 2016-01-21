defmodule Filter.Limit do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(t, {pid}) do
      Filter.Limit.get(pid, t)
      {:ok, {pid}}
    end
  end

  def new(min \\ 0.0, max \\ 1.0) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{min, max}, event_pid})
    {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler}}
  end

  def get(pid, input) do
    GenServer.call(pid, {:get, input})
  end

  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end

  def call(input, {min, _}) when input < min do
    min
  end

  def call(input, {_, max}) when input > max do
    max
  end

  def call(input, {_, _}) do
    input
  end

  def handle_call(:inspect, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:get, input}, _from, {state, event_pid}) do
    output = __MODULE__.call(input, state)
    GenEvent.notify(event_pid, output)
    {:reply, output, {state, event_pid}}
  end

  def handle_call({:set, {:min, value}}, _from, {{_, max}, event_pid}) do
    {:reply, :ok, {{value, max}, event_pid}}
  end

  def handle_call({:set, {:max, value}}, _from, {{min, _}, event_pid}) do
    {:reply, :ok, {{min, value}, event_pid}}
  end
end
