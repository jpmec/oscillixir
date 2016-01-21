defmodule Sink.File do
  use GenServer

  defstruct server: :nil, file: :nil, input: :nil

  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Sink.File.write(pid, input)
      {:ok, {pid}}
    end
  end

  def new(filename \\ "file.pcm") do
    {:ok, file_pid} = File.open(filename, [:write])
    {:ok, pid} = GenServer.start_link(__MODULE__, {{filename}, file_pid})
    {:ok, %__MODULE__{server: pid, file: file_pid, input: __MODULE__.InputHandler}}
  end

  def write(pid, input) do
    GenServer.call(pid, {:write, input})
  end

  def handle_call({:write, input}, _from, {{filename}, file_pid}) do

    :ok = IO.binwrite file_pid, <<input :: size(8)>>

    {:reply, :ok, {{filename}, file_pid}}
  end

end
