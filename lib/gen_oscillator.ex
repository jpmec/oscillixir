defmodule GenOscillator do

  defmacro __using__(parent) do
    quote do
      use GenServer

      defstruct server: :nil, event: :nil, input: :nil


      defmodule InputHandler do
        use GenEvent

        def handle_event(t, {pid}) do
          unquote(parent).get(pid, t)
          {:ok, {pid}}
        end
      end


      def init(state) do
        __MODULE__.start_link(state)
      end


      def start_link(state) do
        {:ok, event_pid} = GenEvent.start_link([])
        {:ok, pid} = GenServer.start_link(__MODULE__, {state, event_pid})
        {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler}}
      end


      def get(pid, t) do
        GenServer.call(pid, {:get, t})
      end


      def handle_call({:get, input}, _from, {state, event_pid}) do
        {output, new_state} = __MODULE__.call(input, state)

        GenEvent.notify(event_pid, output)

        {:reply, output, {new_state, event_pid}}
      end
    end
  end

end
