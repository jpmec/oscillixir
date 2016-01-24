defmodule Connect do

  def connect({:ok, from}, to) do
    :ok = GenEvent.add_handler(from.event, {to.input, to.server}, {to.server})
    to
  end

  def connect(from, {:ok, to}) do
    :ok = GenEvent.add_handler(from.event, {to.input, to.server}, {to.server})
    to
  end

  def connect(from, to) do
    :ok = GenEvent.add_handler(from.event, {to.input, to.server}, {to.server})
    to
  end

  def connect(from, to, control) do
    :ok = GenEvent.add_handler(from.event, {Map.get(to.controls, control), to.server}, {to.server})
    to
  end

end
