defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel
  alias Memory.Game

  def join("game:", payload, socket) do
    {:ok, Game.new(), socket}
  end

  def handle_in("item_clicked", %{"itemProps" => itemProps, "gameState" => gameState}, socket) do
    state = Game.handleItemClick(itemProps, gameState)
    {:reply, {:ok, state}, socket}
  end

  def handle_in("game_reset", _payload, socket) do
    state = Game.handleGameReset()
    {:reply, {:ok, state}, socket}
  end

  # TODO authorize
end
