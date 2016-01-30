defmodule Filter.Gain do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil, gain: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Filter.Gain.get(pid, input)
      {:ok, {pid}}
    end
  end

  defmodule GainHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Filter.Gain.set(pid, {:gain, input})
      {:ok, {pid}}
    end
  end


  def new(gain \\ 1.0) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{gain}, event_pid})
    {:ok, %__MODULE__{
      server: pid,
      event: event_pid,
      input: __MODULE__.InputHandler,
      gain: __MODULE__.GainHandler
    }}
  end

  def get(pid, input) do
    GenServer.call(pid, {:get, input})
  end

  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def call({t, input}, {gain}) do
    {t, input * gain}
  end

  def handle_call(:inspect, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:get, input}, _from, {state, event_pid}) do
    output = __MODULE__.call(input, state)
    GenEvent.notify(event_pid, output)
    {:reply, output, {state, event_pid}}
  end

  def handle_call({:set, {:gain, value}}, _from, {{_}, event_pid}) do
    {:reply, :ok, {{value}, event_pid}}
  end
end
