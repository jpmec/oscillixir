defmodule GenOscillator do

  defmacro __using__(parent) do
    quote do
      use GenServer

      defmodule Control do
        defstruct amplitude: :nil, frequency: :nil, phase: :nil, bias: :nil, period: :nil
      end

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


      def start_link(state, control) do
        {:ok, event_pid} = GenEvent.start_link([])
        {:ok, pid} = GenServer.start_link(__MODULE__, {state, control, event_pid})
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


      def handle_call({:get, input}, _from, {state, control, event_pid}) do
        {output, new_state} = __MODULE__.call(input, state, control)

        GenEvent.sync_notify(event_pid, output)

        {:reply, output, {new_state, control, event_pid}}
      end


      def handle_call(:inspect, _from, {state, event_pid}) do
        {:reply, state, {state, event_pid}}
      end


      def handle_call({:set, {:amplitude, {t, value}}}, _from, {state, control, event_pid}) do
        {:reply, :ok, {state, %{control | amplitude: value}, event_pid}}
      end


      def handle_call({:set, {:frequency, {t, value}}}, _from, {state, control, event_pid}) do
        period =
          if (0.0 == value) do
            0.0
          else
            1.0/value
          end

        {:reply, :ok, {state, %{control | frequency: value, period: period}, event_pid}}
      end

    end
  end

end
