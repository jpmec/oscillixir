defmodule Filter.Gain do
  use GenServer

  defmodule Control do
    defstruct gain: :nil
  end

  defstruct server: :nil, event: :nil, input: :nil, controls: :nil

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

    state = :nil

    control = %Control{
      gain: gain
    }

    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {state, control, event_pid})
    {:ok, %__MODULE__{
      server: pid,
      event: event_pid,
      input: __MODULE__.InputHandler,
      controls: %{
        gain: __MODULE__.GainHandler
      }

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

  def call({t, input}, state, control) do
    {{t, input * control.gain}, state}
  end

  def handle_call({:get, input}, _from, {state, control, event_pid}) do
    {output, new_state} = __MODULE__.call(input, state, control)

    GenEvent.sync_notify(event_pid, output)

    {:reply, output, {new_state, control, event_pid}}
  end

  def handle_call({:set, {:gain, {t, value}}}, _from, {state, control, event_pid}) do
    {:reply, :ok, {state, %{control | gain: value}, event_pid}}
  end
end
