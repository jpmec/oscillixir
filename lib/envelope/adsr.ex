defmodule Envelope.Adsr do

  use GenEnvelope, Envelope.Adsr

  def new(trigger \\ 0.0, attack \\ 0.0, decay \\ 0.0, sustain \\ 1.0, release \\ 0.0) do
    __MODULE__.start_link(
      {:trigger, 0.0, 0.0},
      {trigger, 0.0, attack, 0.0, decay, 0.0, sustain, release}
    )
  end


  def call({t, input}, {:trigger, _, _}, {trigger, _, _, _, _, _, _, _}) do
    if trigger < input do
      {{t, 0.0}, {:attack, t, input}}
    else
      {{t, 0.0}, {:trigger, t, input}}
    end
  end


  def call({t, input}, {:attack, x, y}, {_, _, attack, _, _, _, _, _}) do
    dt = t - x

    if (attack < dt) do
      x = x + attack
      {{t, y}, {:decay, x, y}}
    else
      {{t, y * dt / attack}, {:attack, x, y}}
    end
  end


  def call({t, input}, {:decay, x, y}, {_, _, _, _, decay, _, sustain, _}) do
    dt = t - x

    if (decay < dt) do
      x = x + decay
      {{t, y * sustain}, {:sustain, x, y * sustain}}
    else
      output = y * (1 + dt * (sustain - 1.0) / decay)
      {{t, output}, {:decay, x, y}}
    end
  end


  def call({t, input}, {:sustain, _, y}, {trigger, _, _, _, _, _, sustain, _}) do
    if trigger < input do
      {{t, y}, {:sustain, t, y}}
    else
      {{t, y}, {:release, t, y}}
    end
  end


  def call({t, input}, {:release, x, y}, {_, _, _, _, _, _, sustain, release}) do
    dt = t - x

    if (release < dt) do
      {{t, 0.0}, {:trigger, x + release, 0.0}}
    else
      output = y * (1 - dt / release)
      {{t, output}, {:release, x, y}}
    end
  end

end
