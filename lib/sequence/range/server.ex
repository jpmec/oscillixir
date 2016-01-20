defmodule Sequence.Range.Server do

  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(_, {pid}) do
      Sequence.Range.Server.get(pid)
      {:ok, {pid}}
    end
  end

  def new(length \\ 43, increment \\ 23, at \\ 0) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {at, length, increment, event_pid})
    {:ok, %Sequence.Range.Server{server: pid, event: event_pid, input: Sequence.Range.Server.InputHandler}}
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def event(pid) do
    GenServer.call(pid, :event_pid)
  end

  def handle_call(:inspect, _from, {at, length, increment, event_pid}) do
    {:reply, {:ok, at, length, increment, event_pid}, {at, length, increment, event_pid}}
  end

  def handle_call(:get, _from, {at, length, increment, event_pid}) do
    result = for i <- 0..length-1, do: at + i*increment
    at = List.last(result) + increment

    GenEvent.notify(event_pid, result)
    {:reply, result, {at, length, increment, event_pid}}
  end

  def handle_call(:event_pid, _from, {at, length, increment, event_pid}) do
    {:reply, {:ok, event_pid}, {at, length, increment, event_pid}}
  end
end
