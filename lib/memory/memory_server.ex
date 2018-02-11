defmodule Memory.Server do
  use GenServer
  use MemoryWeb, :channel
  alias Memory.Game
  alias Memory.MemoryAgent

  def start_link() do
    IO.puts("START LINK ...")
    IO.puts(__MODULE__)
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def handle_info({:hide_guess, socket, gameName, %{gameState: gS, itemProps: iP}}, state) do
    IO.puts("HANDLE INFO ...")
    pP = gS["prevItemProps"]
    pP = Map.put(iP, "isHidden", true)
    iP = Map.put(iP, "isHidden", true)
    gS = Game.updateItem(pP, gS)
    gS = Game.updateItem(iP, gS)
    gS = Map.put(gS, "isEnabled", true)
    gS = Game.updateEnabled(gS)
    IO.inspect(gS)
    MemoryAgent.save(gameName, %{gameState: gS, itemProps: iP})
    IO.inspect(gS)
    broadcast!(socket, "update", gS)
    {:noreply, state}
  end
end
