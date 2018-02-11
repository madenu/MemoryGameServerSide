defmodule Memory.MemoryAgent do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(name, gameStateAndItemProps) do
    Agent.update(__MODULE__, fn gSAIP ->
      Map.put(gSAIP, name, gameStateAndItemProps)
    end)
  end

  def load(name) do
    Agent.get(__MODULE__, fn agentStateDict ->
      agentStateDict[name]
    end)
  end

  def handle_info(:enable, state) do
    {:noreply, state}
  end
end
