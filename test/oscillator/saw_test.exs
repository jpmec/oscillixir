defmodule Oscillator.SawTest do
  use ExUnit.Case
  doctest Oscillator.Saw


  test "all 0" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new(1)
    {:ok, saw} = Oscillator.Saw.new(0.0, 0.0, 0.0, 0.0)
    {:ok, result_sink} = Sink.List.new()

    timer |> connect(range) |> connect(saw) |> connect(result_sink)

    Source.Timer.tick(timer.server)
    :timer.sleep(1)

    result = Sink.List.get(result_sink.server)

    assert 0.0 == Enum.at(result, 0)
  end


  test "t0" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new(1)
    {:ok, saw} = Oscillator.Saw.new()
    {:ok, range_sink} = Sink.List.new()
    {:ok, saw_sink} = Sink.List.new()

    timer |> connect(range)

    range |> connect(range_sink)
    range |> connect(saw) |> connect(saw_sink)

    Source.Timer.tick(timer.server)
    :timer.sleep(1)

    input_list = Sink.List.get(range_sink.server)
    list = Sink.List.get(saw_sink.server)

    assert -2.0 == Enum.at(list, 0)

    IO.inspect(input_list)
    IO.inspect(list)
  end


  test "1 tick" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new(10)
    {:ok, saw} = Oscillator.Saw.new()
    {:ok, sink} = Sink.List.new()

    timer |> connect(range) |> connect(saw) |> connect(sink)

    Source.Timer.tick(timer.server)

    :timer.sleep(1000)

    list = Sink.List.get(sink.server)

    assert -2.0 == Enum.at(list, 0)

    IO.inspect(list)
  end

end