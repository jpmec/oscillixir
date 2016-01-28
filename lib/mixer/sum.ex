defmodule Mixer.Sum do

  use GenMixer, Mixer.Sum

  def new(channel_count \\ 1) do
    __MODULE__.start_link(
      %{},
      %Control{
        channel_count: channel_count
      }
    )
  end


  def call({t, input}, state, control) do

    new_state = Dict.update state, t, [input], fn(values) ->
      [input | values]
    end

    values = Dict.get new_state, t

    if control.channel_count == Enum.count(values) do
        output = Enum.sum values
        new_state = Dict.delete new_state, t
        {{t, output}, new_state}
    else
        {{t, :nil}, new_state}
    end
  end

end
