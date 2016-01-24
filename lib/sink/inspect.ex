defmodule Sink.Inspect do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Sink.Inspect.put(pid, input)
      {:ok, {pid}}
    end
  end

  def new(preamble \\ :nil) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{preamble}, :event_pid})
    {:ok, %__MODULE__{server: pid, event: :event_pid, input: __MODULE__.InputHandler}}
  end

  def put(pid, input) do
    GenServer.call(pid, {:inspect, input})
  end

  def handle_call({:inspect, input}, _from, {{:nil}, :event_pid}) do
    IO.inspect(input)
    {:reply, :ok, {{:nil}, :event_pid}}
  end

  def handle_call({:inspect, input}, _from, {{preamble}, :event_pid}) do
    IO.inspect(preamble)
    IO.inspect(input)
    {:reply, :ok, {{preamble}, :event_pid}}
  end

end
