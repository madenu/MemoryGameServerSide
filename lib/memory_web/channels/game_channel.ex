defmodule MemoryWeb.GameChannel do
  # join, handle_in, and authorize
  use MemoryWeb, :channel
  alias Memory.Game

  def join("game:", payload, socket) do
    {:ok, Game.new(), socket}
  end

end
