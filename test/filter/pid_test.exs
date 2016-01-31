defmodule Filter.PidTest do
  use ExUnit.Case
  doctest Filter.Pid

  test "impulse" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, impulse} = Oscillator.Impulse.new(100.0, 10.0)
    {:ok, pid} = Filter.Pid.new(0.5, 0.1, 0.3)

    timer
      |> connect(range)
      |> connect(impulse)
      |> connect(pid)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("pid_test_impulse.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
  end


  test "square" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square} = Oscillator.Square.new(80.0, 440.0)
    {:ok, pid} = Filter.Pid.new(0.5, 0.01, 0.4)

    timer
      |> connect(range)
      |> connect(square)
      |> connect(pid)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("pid_test_square.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
  end


end
