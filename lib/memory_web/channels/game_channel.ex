defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel
  alias Memory.Game

  def join("game:" <> gameName, _payload, socket) do
    # TODO load the saved agent state
    {:ok, Game.rejoin(gameName), socket}
  end

  def handle_in(
        "item_clicked:" <> gameName,
        %{"itemProps" => itemProps, "gameState" => gameState},
        socket
      ) do
    state = Game.handleItemClick(gameName, itemProps, gameState, socket)
    {:reply, {:ok, state}, socket}
  end

  def handle_in("game_reset:" <> gameName, _payload, socket) do
    state = Game.handleGameReset(gameName)
    {:reply, {:ok, state}, socket}
  end

  # TODO authorize
end
