defmodule GenSink do

  defmacro __using__(parent) do
    quote location: :keep do
      use GenServer

      defstruct server: :nil, event: :nil, input: :nil

      defmodule InputHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).put(pid, input)
          {:ok, {pid}}
        end
      end

      def start_link(state) do
        {:ok, event_pid} = GenEvent.start_link([])
        {:ok, pid} = GenServer.start_link(__MODULE__, {state, event_pid})
        {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler}}
      end

      def get(pid) do
        GenServer.call(pid, {:get})
      end

      def put(pid, input) do
        GenServer.call(pid, {:put, input})
      end

      def handle_call({:get}, _from, {state, event_pid}) do
        {output, new_state} = __MODULE__.call({:get}, state)
        {:reply, output, {new_state, event_pid}}
      end

      def handle_call({:put, input}, _from, {state, event_pid}) do
        {output, new_state} = __MODULE__.call({:put, input}, state)
        {:reply, output, {new_state, event_pid}}
      end
    end
  end

end
