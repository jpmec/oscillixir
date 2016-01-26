defmodule GenEnvelope do

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


      defmodule DelayHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:delay, input})
          {:ok, {pid}}
        end
      end


      defmodule TriggerHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:trigger, input})
          {:ok, {pid}}
        end
      end


      defmodule AttackHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:attack, input})
          {:ok, {pid}}
        end
      end


      defmodule AttackHoldHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:attack_hold, input})
          {:ok, {pid}}
        end
      end


      defmodule DecayHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:decay, input})
          {:ok, {pid}}
        end
      end


      defmodule DecayHoldHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:decay_hold, input})
          {:ok, {pid}}
        end
      end


      defmodule SustainHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:sustain, input})
          {:ok, {pid}}
        end
      end


      defmodule ReleaseHandler do
        use GenEvent

        def handle_event(input, {pid}) do
          unquote(parent).set(pid, {:release, input})
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
            trigger: __MODULE__.TriggerHandler,
            delay: __MODULE__.DelayHandler,
            attack: __MODULE__.AttackHandler,
            attack_hold: __MODULE__.AttackHold,
            decay: __MODULE__.DecayHandler,
            decay_hold: __MODULE__.DecayHoldHandler,
            sustain: __MODULE__.SustainHandler,
            release: __MODULE__.ReleaseHandler
          }
        }}
      end


      def get(pid, input) do
        GenServer.call(pid, {:get, input})
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


      def handle_call(:inspect, _from, {state, control, event_pid}) do
        {:reply, {state, control}, {state, event_pid}}
      end


      def handle_call({:set, {:trigger, {t, value}}}, _from, {state, {_, delay, attack, attack_hold, decay, decay_hold, sustain, release}, event_pid}) do
        {:reply, :ok, {state, {value, delay, attack, attack_hold, decay, decay_hold, sustain, release}, event_pid}}
      end

      def handle_call({:set, {:delay, {t, value}}}, _from, {state, {trigger, _, attack, attack_hold, decay, decay_hold, sustain, release}, event_pid}) do
        {:reply, :ok, {state, {trigger, value, attack, attack_hold, decay, decay_hold, sustain, release}, event_pid}}
      end

      def handle_call({:set, {:attack, {t, value}}}, _from, {state, {trigger, delay, _, attack_hold, decay, decay_hold, sustain, release}, event_pid}) do
        {:reply, :ok, {state, {trigger, delay, value, attack_hold, decay, decay_hold, sustain, release}, event_pid}}
      end

      def handle_call({:set, {:attack_hold, {t, value}}}, _from, {state, {trigger, delay, attack, _, decay, decay_hold, sustain, release}, event_pid}) do
        {:reply, :ok, {state, {trigger, delay, attack, value, decay, decay_hold, sustain, release}, event_pid}}
      end

      def handle_call({:set, {:decay, {t, value}}}, _from, {state, {trigger, delay, attack, attack_hold, _, decay_hold, sustain, release}, event_pid}) do
        {:reply, :ok, {state, {trigger, delay, attack, attack_hold, value, decay_hold, sustain, release}, event_pid}}
      end

      def handle_call({:set, {:decay_hold, {t, value}}}, _from, {state, {trigger, delay, attack, attack_hold, decay, _, sustain, release}, event_pid}) do
        {:reply, :ok, {state, {trigger, delay, attack, attack_hold, decay, value, sustain, release}, event_pid}}
      end

      def handle_call({:set, {:sustain, {t, value}}}, _from, {state, {trigger, delay, attack, attack_hold, decay, decay_hold, _, release}, event_pid}) do
        {:reply, :ok, {state, {trigger, delay, attack, attack_hold, decay, decay_hold, value, release}, event_pid}}
      end

      def handle_call({:set, {:release, {t, value}}}, _from, {state, {trigger, delay, attack, attack_hold, decay, decay_hold, sustain, _}, event_pid}) do
        {:reply, :ok, {state, {trigger, delay, attack, attack_hold, decay, decay_hold, sustain, value}, event_pid}}
      end

    end
  end

end
