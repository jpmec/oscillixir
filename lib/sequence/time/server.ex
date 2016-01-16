defmodule Sequence.Time.Server do

  use GenServer

  def new(interval \\ 1000) do
    GenServer.start_link(__MODULE__, {0, interval, 0})
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

  def next(pid) do
    GenServer.call(pid, :get)
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def tick(pid) do
    GenServer.call(pid, :next)
  end

  def handle_call({:start, pid}, _from, {t, interval, tref}) do
    {:ok, tref} = :timer.apply_interval(interval, __MODULE__, :tick, [pid])
    {:reply, {:ok, t, interval, tref}, {t, interval, tref}}
  end

  def handle_call(:stop, _from, {t, interval, 0}) do
    {:reply, {:ok, t, interval, 0}, {0, interval, 0}}
  end

  def handle_call(:stop, _from, {t, interval, tref}) do
    {:ok, :cancel} = :timer.cancel(tref)
    {:reply, {:ok, t, interval, tref}, {0, interval, 0}}
  end

  def handle_call(:inspect, _from, {t, interval, tref}) do
    {:reply, {:ok, t, interval, tref}, {t, interval, tref}}
  end

  def handle_call(:get, _from, {t, interval, tref}) do
    {:reply, {:ok, t}, {t, interval, tref}}
  end

  def handle_call(:next, _from, {t, interval, tref}) do
    {:reply, {:ok, t}, {t + 1, interval, tref}}
  end

  def handle_call(:started?, _from, {t, interval, tref}) do
    {:reply, {:ok, tref}, {t, interval, tref}}
  end

end
