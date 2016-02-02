defmodule Mixer.SumTest do
  use ExUnit.Case
  doctest Mixer.Sum


  test "simple" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square0} = Oscillator.Square.new(40.0, 330.0)
    {:ok, square1} = Oscillator.Square.new(80.0, 550.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)
    range |> connect(square0)
    range |> connect(square1)

    square0 |> connect(sum)
    square1 |> connect(sum)

    sum
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("temp/test/mixer/sum_test_simple.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
  end


  test "unity sine" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, sine1} = Oscillator.Sine.new(1.0, 440.0)
    {:ok, sine2} = Oscillator.Sine.new(1.0, 440.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(sine1) |> connect(sum)
    range |> connect(sine2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_sine.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end


  test "unity sine detune" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, sine1} = Oscillator.Sine.new(1.0, 440.0)
    {:ok, sine2} = Oscillator.Sine.new(1.0, 430.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(sine1) |> connect(sum)
    range |> connect(sine2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_sine_detune.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end


  test "unity square" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square1} = Oscillator.Square.new(1.0, 440.0)
    {:ok, square2} = Oscillator.Square.new(1.0, 440.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(square1) |> connect(sum)
    range |> connect(square2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_square.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end


  test "unity square detune" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square1} = Oscillator.Square.new(1.0, 440.0)
    {:ok, square2} = Oscillator.Square.new(1.0, 430.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(square1) |> connect(sum)
    range |> connect(square2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_square_detune.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end


  test "unity triangle" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, triangle1} = Oscillator.Triangle.new(1.0, 440.0)
    {:ok, triangle2} = Oscillator.Triangle.new(1.0, 440.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(triangle1) |> connect(sum)
    range |> connect(triangle2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_triangle.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end


  test "unity triangle detune" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, triangle1} = Oscillator.Triangle.new(1.0, 440.0)
    {:ok, triangle2} = Oscillator.Triangle.new(1.0, 430.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(triangle1) |> connect(sum)
    range |> connect(triangle2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_triangle_detune.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end




  test "unity square triangle" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square1} = Oscillator.Square.new(1.0, 440.0)
    {:ok, triangle2} = Oscillator.Triangle.new(1.0, 440.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(square1) |> connect(sum)
    range |> connect(triangle2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_square_triangle.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end


  test "unity square triangle detune" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, square1} = Oscillator.Square.new(1.0, 440.0)
    {:ok, triangle2} = Oscillator.Triangle.new(1.0, 430.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(square1) |> connect(sum)
    range |> connect(triangle2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_square_triangle_detune.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end



  test "unity sine triangle" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, sine1} = Oscillator.Sine.new(1.0, 440.0)
    {:ok, triangle2} = Oscillator.Triangle.new(1.0, 440.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(sine1) |> connect(sum)
    range |> connect(triangle2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_sine_triangle.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end


  test "unity sine triangle detune" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new()
    {:ok, sine1} = Oscillator.Sine.new(1.0, 440.0)
    {:ok, triangle2} = Oscillator.Triangle.new(1.0, 430.0)
    {:ok, sum} = Mixer.Sum.new(2)

    timer |> connect(range)

    range |> connect(sine1) |> connect(sum)
    range |> connect(triangle2) |> connect(sum)

    sum
      |> connect(Filter.Gain.new(50.0))
      |> connect(Filter.Round.new())
      |> connect(Sink.File.new("sum_test_unity_sine_triangle_detune.pcm"))

    Source.Timer.start(timer.server)
    :timer.sleep(1000)
    Source.Timer.stop(timer.server)
    :timer.sleep(1000)
  end


end
