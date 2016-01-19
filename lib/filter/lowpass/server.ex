defmodule Filter.Lowpass.Server do
  use GenServer


  defmodule InputHandler do
    use GenEvent

    def handle_event({:y, y}, {pid}) do
      Filter.Lowpass.Server.get(pid, y)
      {:ok, {pid}}
    end
  end


  def new(alpha \\ 1.0) do
    {:ok, event_pid} = GenEvent.start_link([])
    GenServer.start_link(__MODULE__, {0, alpha, event_pid})
  end

  def get(pid, x) do
    GenServer.call(pid, {:get, x})
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def event(pid) do
    GenServer.call(pid, :event_pid)
  end

  def filter([x | []], y, alpha) do
    {z, _} = Filter.Lowpass.Server.filter(x, y, alpha)
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

  def handle_call(:inspect, _from, {y, alpha, event_pid}) do
    {:reply, {:ok, y, alpha, event_pid}, {y, alpha, event_pid}}
  end

  def handle_call({:get, x}, _from, {y, alpha, event_pid}) do
    {result, y} = Filter.Lowpass.Server.filter(x, y, alpha)
    GenEvent.notify(event_pid, {:y, result})
    {:reply, {:ok, result}, {y, alpha, event_pid}}
  end

  def handle_call(:event_pid, _from, {y, alpha, event_pid}) do
    {:reply, {:ok, event_pid}, {y, alpha, event_pid}}
  end

end
