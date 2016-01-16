# Oscillixir

An attempt at making a sound oscillator in Elixir.


## Background Research and Design Choices

The current sample rate for CD-quality audio is 44,100 samples per second.
We would like to create an oscillator that can generate at at least twice that frequency.

2 * 44100 samples/second = 88200 sample/second

1/88200 second/samples = 0.000013378684807256 second/sample



The Erlang timer is only accurate to 1 millisecond.



:math.sin/1 is the Erlang sine function










## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add oscillixir to your list of dependencies in `mix.exs`:

        def deps do
          [{:oscillixir, "~> 0.0.1"}]
        end

  2. Ensure oscillixir is started before your application:

        def application do
          [applications: [:oscillixir]]
        end
