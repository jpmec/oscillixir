defmodule Filter.Gate do
  use GenServer

  defmodule Control do
    defstruct threshold: :nil
  end

  defstruct server: :nil, event: :nil, input: :nil, controls: :nil


  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Filter.Gate.get(pid, input)
      {:ok, {pid}}
    end
  end


  def new(threshold \\ 0.0) do

    state = :nil
    control = %Control {
        threshold: threshold
    }


    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {state, control, event_pid})
    {:ok,
      %__MODULE__{
        server: pid,
        event: event_pid,
        input: __MODULE__.InputHandler
      }
    }
  end

  def get(pid, input) do
    GenServer.call(pid, {:get, input})
  end

  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end


  def call({t, y}, state, control) do
    if (control.threshold < abs(y)) do
      {{t, y}, state}
    else
      {{t, 0.0}, state}
    end
  end

  def handle_call(:inspect, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:get, input}, _from, {state, control, event_pid}) do
    {output, new_state} = __MODULE__.call(input, state, control)

    GenEvent.notify(event_pid, output)

    {:reply, output, {new_state, control, event_pid}}
  end

end
