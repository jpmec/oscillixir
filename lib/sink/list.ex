defmodule Sink.List do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Sink.List.put(pid, input)
      {:ok, {pid}}
    end
  end

  def new() do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {[], :event_pid})
    {:ok, %__MODULE__{server: pid, event: :event_pid, input: __MODULE__.InputHandler}}
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def put(pid, input) do
    GenServer.call(pid, {:put, input})
  end

  def handle_call({:put, input}, _from, {[], :event_pid}) do
    {:reply, :ok, {[input], :event_pid}}
  end

  def handle_call({:put, input}, _from, {tail, :event_pid}) do
    {:reply, :ok, {[input | tail], :event_pid}}
  end

  def handle_call(:get, _from, {list, :event_pid}) do
    {:reply, :lists.reverse(list), {list, :event_pid}}
  end

end
