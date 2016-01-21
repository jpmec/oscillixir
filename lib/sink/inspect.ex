defmodule Sink.Inspect do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Sink.Inspect.inspect(pid, input)
      {:ok, {pid}}
    end
  end

  def new(preamble \\ :nil) do
    {:ok, pid} = GenServer.start_link(__MODULE__, {{preamble}, :nil})
    {:ok, %Sink.Inspect{server: pid, event: :nil, input: Sink.Inspect.InputHandler}}
  end

  def inspect(pid, input) do
    GenServer.call(pid, {:inspect, input})
  end

  def handle_call({:inspect, input}, _from, {{:nil}, :nil}) do
    IO.inspect(input)
    {:reply, :ok, {{:nil}, :nil}}
  end

  def handle_call({:inspect, input}, _from, {{preamble}, :nil}) do
    IO.inspect(preamble)
    IO.inspect(input)
    {:reply, :ok, {{preamble}, :nil}}
  end

end
