defmodule Sequence.Range.Server do

  use GenServer

  def new(length \\ 10) do
    GenServer.start_link(__MODULE__, {length})
  end

  def get(pid, start) do
    GenServer.call(pid, {:get, start})
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def handle_call(:inspect, _from, {length}) do
    {:reply, {:ok, length}, {length}}
  end

  def handle_call({:get, start}, _from, {length}) do
    {:reply, {:ok, start..(start+length)}, {length}}
  end

end
