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


      defmodule AmplitudeHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:amplitude, input})
          {:ok, {pid}}
        end
      end


      defmodule FrequencyHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:frequency, input})
          {:ok, {pid}}
        end
      end


      def start_link(state) do
        {:ok, event_pid} = GenEvent.start_link([])
        {:ok, pid} = GenServer.start_link(__MODULE__, {state, event_pid})
        {:ok, %__MODULE__{
          server: pid,
          event: event_pid,
          input: __MODULE__.InputHandler,
          controls: %{
            amplitude: __MODULE__.AmplitudeHandler,
            frequency: __MODULE__.FrequencyHandler
          }
        }}
      end


      def get(pid, t) do
        GenServer.call(pid, {:get, t})
      end


      def set(pid, input) do
        GenServer.call(pid, {:set, input})
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


      def handle_call({:set, {:amplitude, {t, value}}}, _from, {{_, frequency, phase, bias, period, x, y}, event_pid}) do
        {:reply, :ok, {{value, frequency, phase, bias, period, x, y}, event_pid}}
      end


      def handle_call({:set, {:frequency, {t, value}}}, _from, {{amplitude, _, phase, bias, _, x, y}, event_pid}) do
        new_period =
          if (0.0 == value) do
            0.0
          else
            1.0/value
          end

        {:reply, :ok, {{amplitude, value, phase, bias, new_period, x, y}, event_pid}}
      end

    end
  end

end
