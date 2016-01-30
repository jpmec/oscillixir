defmodule Oscillator.SquareTest do
  use ExUnit.Case
  doctest Oscillator.Square

  # test "1 tick" do
  #   import Connect

  #   {:ok, timer} = Source.Timer.new()
  #   {:ok, range} = Sequence.Range.new(10)
  #   {:ok, square} = Oscillator.Square.new()
  #   {:ok, sink} = Sink.List.new()

  #   timer |> connect(range) |> connect(square) |> connect(sink)

  #   Source.Timer.tick(timer.server)

  #   :timer.sleep(100)

  #   list = Sink.List.get(sink.server)

  #   assert 10 == Enum.count(list)
  #   assert {0.0, 1.0} == Enum.at(list, 0)

  #   IO.inspect(list)
  # end




  test "control_frequency_and_amplitude" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square} = Oscillator.Square.new(127.0)
    {:ok, frequency_sine} = Oscillator.Sine.new(110.0, 5.0, 0.0, 330.0)
    {:ok, amplitude_sine} = Oscillator.Sine.new(17.0, 7.0, 0.0, 110.0)

    timer |> connect(range)

    range
      |> connect(frequency_sine)
      |> connect(square, :frequency)

    range
      |> connect(amplitude_sine)
      |> connect(square, :amplitude)

    range
      |> connect(square)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("square_test_control_frequency_and_amplitude.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end

end
