# Oscillixir

An attempt at making an audio synthesizer in Elixir.


## Components

### Time Source
The Source.Timer module provides a time source for audio signal.
It periodically notifies the Sequence.Range which creates a series of time values.

By default:

    * The Source.Timer generates an event notification every 10 ms.
    * The Sequence.Range generates 441 time events with interval of 0.000022675736961451248.

The result is a sequence of time events representing 44100 Hz.

### Oscillators
An Oscillator is notified with a time, and creates a signal event.
The supported oscillators are:

    * Square
    * Saw
    * Triangle
    * Sine



## Background Research and Design Choices

For CD-quality audio:
* the sample rate is 44,100 samples per second.
* has a sample size of 16 bits
* has 2 channels

The common range of human hearing is 20 Hz to 20 kHz.  Humans can hear as low as 12 Hz.

1/44100 second/samples = 0.000022675736961451248 second/sample ~= 23 microsecond/sample

(0.001 second) / (0.000023 second/sample) = 43.47826086956522 samples ~= 43 samples


The Erlang timer is only accurate to 1 millisecond.
Erlang rem function only works on integers.
:math.sin/1 is the Erlang sine function


The base time unit will be 1 microsecond.
This allows many of the calculations to be performed as integers.








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
