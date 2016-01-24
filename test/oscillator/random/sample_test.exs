defmodule Oscillator.Random.SampleTest do
  use ExUnit.Case
  doctest Oscillator.Random.Sample

  test "new" do
     {:ok, sample} = Oscillator.Random.Sample.new([440.0])

     IO.inspect Oscillator.Random.Sample.inspect(sample.server)
  end

  test "get 1" do
    {:ok, sample} = Oscillator.Random.Sample.new([440.0])

    result = Oscillator.Random.Sample.get(sample.server, 0.0)

    IO.inspect result
  end

  test "1 tick" do
    import Connect

    {:ok, timer} = Source.Timer.new()
    {:ok, range} = Sequence.Range.new(4)
    {:ok, sample} = Oscillator.Random.Sample.new([110.0, 220.0, 440.0])
    {:ok, sink} = Sink.List.new()

    timer |> connect(range) |> connect(sample) |> connect(sink)

    Source.Timer.tick(timer.server)

    :timer.sleep(100)

    list = Sink.List.get(sink.server)

#    assert 6 == Enum.count(list)
#    assert {0.0, 0.0} == Enum.at(list, 0)

    IO.inspect(list)
  end

end
