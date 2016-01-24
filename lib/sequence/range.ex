defmodule Sequence.Range do
  use GenServer

  defstruct server: :nil, event: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(_, {pid}) do
      Sequence.Range.get(pid)
      {:ok, {pid}}
    end
  end

  def new(length \\ 441, increment \\ 0.000022675736961451248, at \\ 0.0) do
    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{at, length, increment}, event_pid})
    {:ok, %Sequence.Range{server: pid, event: event_pid, input: Sequence.Range.InputHandler}}
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def handle_call(:get, _from, {{at, length, increment}, event_pid}) do
    output = for i <- 0..length-1, do: at + i*increment
    at = List.last(output) + increment

    output |> Enum.each(fn(y) -> GenEvent.sync_notify(event_pid, y) end)

    {:reply, output, {{at, length, increment}, event_pid}}
  end
end
