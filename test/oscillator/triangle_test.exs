defmodule Oscillator.TriangleTest do
  use ExUnit.Case
  doctest Oscillator.Triangle

  test "1 tick" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new(10)
    {:ok, triangle} = Oscillator.Triangle.new()
    {:ok, sink} = Sink.List.new()

    timer |> connect(range) |> connect(triangle) |> connect(sink)

    Source.Timer.tick(timer.server)

    :timer.sleep(100)

    list = Sink.List.get(sink.server)

    assert 10 == Enum.count(list)
    assert {0.0, 0.0} == Enum.at(list, 0)

    IO.inspect(list)
  end


  test "constant" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, triangle} = Oscillator.Triangle.new(120.0)

    timer
      |> connect(range)
      |> connect(triangle)
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("temp/test/oscillator/triangle_test_constant.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end


  test "440" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, triangle} = Oscillator.Triangle.new(1.0, 440.0)

    timer
      |> connect(range)
      |> connect(triangle)
      |> connect(Filter.Gain.new(100.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("temp/test/oscillator/triangle_test_440.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end





  # test "control frequency and amplitude" do
  #   import Connect

  #   {:ok, timer} = Source.Timer.new()
  #   {:ok, range} = Sequence.Range.new()
  #   {:ok, triangle} = Oscillator.Triangle.new(127.0)
  #   {:ok, frequency_sine} = Oscillator.Sine.new(41.25, 1.0, 0.0, 68.75)
  #   {:ok, amplitude_sine} = Oscillator.Sine.new(63.5, 2.0, 0.0, 63.5)

  #   timer |> connect(range)

  #   range
  #     |> connect(frequency_sine)
  #     |> connect(triangle, :frequency)

  #   range
  #     |> connect(amplitude_sine)
  #     |> connect(triangle, :amplitude)

  #   range
  #     |> connect(triangle)
  #     |> connect(Filter.Round.new())
  #     |> connect(Sink.File.new())

  #   Source.Timer.tick(timer.server)

  #   :timer.sleep(100)

  #   list = Sink.List.get(sink.server)

  #   assert 10 == Enum.count(list)
  #   assert {0.0, 0.0} == Enum.at(list, 0)

  #   IO.inspect(list)
  # end

end
