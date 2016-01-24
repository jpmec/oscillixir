defmodule GenOscillator do

  defmacro __using__(parent) do
    quote do
      use GenServer

      defstruct server: :nil, event: :nil, input: :nil, controls: :nil


      defmodule InputHandler do
        use GenEvent

        def handle_event(t, {pid}) do
          unquote(parent).get(pid, t)
          {:ok, {pid}}
        end
      end


      def start_link(state, controls \\ :nil) do
        {:ok, event_pid} = GenEvent.start_link([])
        {:ok, pid} = GenServer.start_link(__MODULE__, {state, event_pid})
        {:ok, %__MODULE__{server: pid, event: event_pid, input: __MODULE__.InputHandler, controls: controls}}
      end


      def get(pid, t) do
        GenServer.call(pid, {:get, t})
      end


      def inspect(pid) do
        GenServer.call(pid, :inspect)
      end


      def handle_call({:get, input}, _from, {state, event_pid}) do
        {output, new_state} = __MODULE__.call(input, state)

        GenEvent.sync_notify(event_pid, output)

        {:reply, output, {new_state, event_pid}}
      end

      def handle_call(:inspect, _from, {state, event_pid}) do
        {:reply, state, {state, event_pid}}
      end

    end
  end

end
