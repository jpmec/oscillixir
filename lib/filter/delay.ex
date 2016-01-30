defmodule Filter.Delay do
  use GenServer

  defmodule Control do
    defstruct delay: :nil
  end

  defstruct server: :nil, event: :nil, input: :nil, controls: :nil


  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Filter.Delay.get(pid, input)
      {:ok, {pid}}
    end
  end

  defmodule DelayHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Filter.Delay.set(pid, {:delay, input})
      {:ok, {pid}}
    end
  end


  def new(delay \\ 0.0) do

    state = {0.0, :queue.new()}
    control = %Control{
      delay: delay
    }

    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {state, control, event_pid})
    {:ok, %__MODULE__{
      server: pid,
      event: event_pid,
      input: __MODULE__.InputHandler,
      controls: %{
        delay: __MODULE__.DelayHandler
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

  def call({t, input}, {_, q}, control) do
    x = t
    q = {t + control.delay, input} |> :queue.in(q)

    q_len = :queue.len(q)

    case :queue.peek(q) do
      {:value, {delayed_t, y}} ->
        if (delayed_t <= x) do
          {{:value, {delayed_t, y}}, q} = :queue.out(q)
          {{delayed_t, y}, {x, q}}
        else
          {{t, 0.0}, {x, q}}
        end

      true ->
        {{t, 0.0}, {x, q}}
    end
  end

  def handle_call(:inspect, _from, {state, _, event_pid}) do
    {:reply, state, {state, event_pid}}
  end

  def handle_call({:get, input}, _from, {state, control, event_pid}) do
    {output, new_state} = __MODULE__.call(input, state, control)

    GenEvent.notify(event_pid, output)

    {:reply, output, {new_state, control, event_pid}}
  end

  def handle_call({:set, {:delay, {_, value}}}, _from, {state, control, event_pid}) do
    {:reply, :ok, {state, %{control | delay: value}, event_pid}}
  end
end
