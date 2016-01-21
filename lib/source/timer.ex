defmodule Source.Timer do
  @moduledoc """
  Generate a sequence of incrementing values at each timer interval.

  The interval is specified in milliseconds.
  The smallest timer interval is 1 millisecond.
  """
  use GenServer

  defstruct server: :nil, event: :nil

  def new(interval_ms \\ 1000, start_t \\ 0, increment \\ 1) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {start_t, interval_ms, increment, :nil, event_pid})
    {:ok, %Source.Timer{server: pid, event: event_pid}}
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

  def handle_call({:start, pid}, _from, {t, interval, increment, :nil, event_pid}) do
    {:ok, tref} = :timer.apply_interval(interval, __MODULE__, :tick, [pid])
    {:reply, {:ok, t, interval, increment, tref, event_pid}, {t, interval, increment, tref, event_pid}}
  end

  def handle_call({:start, _}, _from, {t, interval, increment, tref, event_pid}) do
    {:reply, {:ok, t, interval, increment, tref, event_pid}, {t, interval, increment, tref, event_pid}}
  end

  def handle_call(:stop, _from, {t, interval, increment, :nil, event_pid}) do
    {:reply, {:ok, t, interval, :nil, event_pid}, {t, interval, increment, :nil, event_pid}}
  end

  def handle_call(:stop, _from, {t, interval, increment, tref, event_pid}) do
    {:ok, :cancel} = :timer.cancel(tref)
    {:reply, {:ok, t, interval, :nil, event_pid}, {t, interval, increment, :nil, event_pid}}
  end

  def handle_call(:inspect, _from, {t, interval, increment, tref, event_pid}) do
    {:reply, {:ok, t, interval, tref, event_pid}, {t, interval, increment, tref, event_pid}}
  end

  def handle_call(:get, _from, {t, interval, increment, tref, event_pid}) do
    {:reply, t, {t, interval, increment, tref, event_pid}}
  end

  def handle_call(:event_pid, _from, {t, interval, increment, tref, event_pid}) do
    {:reply, {:ok, event_pid}, {t, interval, increment, tref, event_pid}}
  end

  def handle_call(:next, _from, {t, interval, increment, tref, event_pid}) do
    t = t + increment
    GenEvent.notify(event_pid, t)
    {:reply, t, {t, interval, increment, tref, event_pid}}
  end

  def handle_call(:started?, _from, {t, interval, increment, tref, event_pid}) do
    {:reply, {:ok, tref}, {t, interval, increment, tref, event_pid}}
  end

end
