defmodule Filter.Lowpass.Server do

  use GenServer

  def new(alpha \\ 1.0) do
    GenServer.start_link(__MODULE__, {0, alpha})
  end

  def get(pid, x) do
    GenServer.call(pid, {:get, x})
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def filter([x | []], y, alpha) do
    {z, y} = Filter.Lowpass.Server.filter(x, y, alpha)
    {[z], z}
  end

  def filter([x | tail], y, alpha) do
    {z, y} = Filter.Lowpass.Server.filter(x, y, alpha)
    {zs, y} = Filter.Lowpass.Server.filter(tail, y, alpha)
    {[z | zs], y}
  end

  def filter(x, y, alpha) do
    z = y + alpha * (x - y)
    {z, z}
  end

  def handle_call(:inspect, _from, {y, alpha}) do
    {:reply, {:ok, y, alpha}, {y, alpha}}
  end

  def handle_call({:get, x}, _from, {y, alpha}) do
    {result, y} = Filter.Lowpass.Server.filter(x, y, alpha)

    {:reply, {:ok, result}, {y, alpha}}
  end

end
