defmodule Filter.Lowpass do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Filter.Lowpass.get(pid, input)
      {:ok, {pid}}
    end
  end

  def new(alpha \\ 1.0) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{0, alpha}, event_pid})
    {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler}}
  end

  def get(pid, input) do
    GenServer.call(pid, {:get, input})
  end

  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end

  def call(input, {y, alpha}) do
    z = y + alpha * (input - y)
    {z, z}
  end

  def handle_call({:get, input}, _from, {state, event_pid}) do
    {output, _} = __MODULE__.call(input, state)
    GenEvent.notify(event_pid, output)
    {:reply, output, {state, event_pid}}
  end

end
