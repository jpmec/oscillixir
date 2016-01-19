defmodule Sequence.Time.Server do

  use GenServer

  def new(interval \\ 1000) do
    {:ok, event_pid} = GenEvent.start_link([])
    GenServer.start_link(__MODULE__, {0, interval, 0, event_pid})
  end

  def start(pid) do
    GenServer.call(pid, {:start, pid})
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end


  def get(pid) do
    GenServer.call(pid, :get)
  end

  def event(pid) do
    GenServer.call(pid, :event_pid)
  end

  def next(pid) do
    GenServer.call(pid, :get)
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def tick(pid) do
    GenServer.call(pid, :next)
  end

  def handle_call({:start, pid}, _from, {t, interval, tref, event_pid}) do
    {:ok, tref} = :timer.apply_interval(interval, __MODULE__, :tick, [pid])
    {:reply, {:ok, t, interval, tref, event_pid}, {t, interval, tref, event_pid}}
  end

  def handle_call(:stop, _from, {t, interval, 0, event_pid}) do
    {:reply, {:ok, t, interval, 0, event_pid}, {0, interval, 0, event_pid}}
  end

  def handle_call(:stop, _from, {t, interval, tref, event_pid}) do
    {:ok, :cancel} = :timer.cancel(tref)
    {:reply, {:ok, t, interval, tref, event_pid}, {0, interval, 0, event_pid}}
  end

  def handle_call(:inspect, _from, {t, interval, tref, event_pid}) do
    {:reply, {:ok, t, interval, tref, event_pid}, {t, interval, tref, event_pid}}
  end

  def handle_call(:get, _from, {t, interval, tref, event_pid}) do
    {:reply, {:ok, t}, {t, interval, tref, event_pid}}
  end

  def handle_call(:event_pid, _from, {t, interval, tref, event_pid}) do
    {:reply, {:ok, event_pid}, {t, interval, tref, event_pid}}
  end

  def handle_call(:next, _from, {t, interval, tref, event_pid}) do
    t = t + 1
    GenEvent.notify(event_pid, {:t, t})
    {:reply, {:ok, t}, {t, interval, tref, event_pid}}
  end

  def handle_call(:started?, _from, {t, interval, tref, event_pid}) do
    {:reply, {:ok, tref}, {t, interval, tref, event_pid}}
  end

end
