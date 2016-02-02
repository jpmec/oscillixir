defmodule Voice.KickDrum do
  use GenServer
  import Connect

  defstruct server: :nil, event: :nil, input: :nil


  defmodule InputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Voice.KickDrum.put(pid, input)
      {:ok, {pid}}
    end
  end


  defmodule OutputHandler do
    use GenEvent

    def handle_event(input, {pid}) do
      Voice.KickDrum.get(pid, input)
      {:ok, {pid}}
    end

  end


  def new(amplitude \\ 1.0) do

    state = :nil
    control = :nil

    {:ok, event_pid} = GenEvent.start_link([])
    {:ok, input_event_pid} = GenEvent.start_link([])

    {:ok, pid} = GenServer.start_link(__MODULE__, {state, control, input_event_pid, event_pid})

    {:ok, adsr} = Envelope.Adsr.new(0.0, 0.001, 0.04, 0.9, 0.01)
    {:ok, sine} = Oscillator.Sine.new(0.0, 80.0)
    {:ok, square} = Oscillator.Square.new(0.5, 55.0, 0.0, 0.5)
    {:ok, mixer1} = Mixer.Product.new(2)
    {:ok, noise} = Oscillator.Random.Uniform.new(0.0, 87.0)
    {:ok, mixer2} = Mixer.Sum.new(2)
    {:ok, gate} = Filter.Gate.new(2.0)

    input_event_pid |> connect_event(adsr) |> connect(sine, :amplitude)
    input_event_pid |> connect_event(square) |> connect(mixer1)
    input_event_pid |> connect_event(sine) |> connect(mixer2) |> connect(mixer1)
    input_event_pid |> connect_event(noise) |> connect(mixer2)

    mixer2 |> connect(gate)

    GenEvent.add_handler(gate.event, {__MODULE__.OutputHandler, pid}, {pid})

    {:ok,
      %__MODULE__{
        server: pid,
        event: event_pid,
        input: __MODULE__.InputHandler
      }
    }
  end


  def put(pid, input) do
    GenServer.call(pid, {:put, input})
  end

  def get(pid, input) do
    GenServer.call(pid, {:get, input})
  end

  def set(pid, input) do
    GenServer.call(pid, {:set, input})
  end

  def handle_call({:put, input}, _from, {state, control, input_event_pid, event_pid}) do
    GenEvent.notify(input_event_pid, input)
    {:reply, :nil, {state, control, input_event_pid, event_pid}}
  end

  def handle_call({:get, input}, _from, {state, control, input_event_pid, event_pid}) do
    GenEvent.notify(event_pid, input)
    {:reply, :nil, {state, control, input_event_pid, event_pid}}
  end

end
