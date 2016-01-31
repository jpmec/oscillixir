defmodule Filter.Pid do
  use GenServer

  defmodule Control do
    defstruct p: :nil, i: :nil, d: :nil
  end

  defstruct server: :nil, event: :nil, input: :nil, controls: :nil


  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Filter.Pid.get(pid, input)
      {:ok, {pid}}
    end
  end


  def new(p \\ 1.0, i \\ 0.0, d \\ 0.0) do

    state = {0.0, 0.0, 0.0}
    control = %Control {
        p: p, i: i, d: d
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


  def call({t, input}, {y, iy, dy}, control) do
    next_dy = input - y
    next_ddy = next_dy - dy
    iy = iy + next_dy

    y = y + control.p * next_dy + control.i * iy + control.d * next_ddy

    {{t, y}, {y, iy, next_dy}}
  end


  def handle_call({:get, input}, _from, {state, control, event_pid}) do
    {output, new_state} = __MODULE__.call(input, state, control)

    GenEvent.notify(event_pid, output)

    {:reply, output, {new_state, control, event_pid}}
  end


end
