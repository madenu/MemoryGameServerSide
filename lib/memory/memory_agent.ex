defmodule Memory.MemoryAgent do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(name, gameStateAndItemProps) do
    Agent.update(__MODULE__, fn gameStatesMap ->
      Map.put(gameStatesMap, name, gameStateAndItemProps)
    end)
  end

  def load(name) do
    Agent.get(__MODULE__, fn agentStateDict ->
      agentStateDict[name]
    end)
  end

  def schedule_work(%{name: gameName, socket: socket}) do
    IO.puts("SCHEDULE WORK ...")

    Process.send_after(
      Elixir.Memory.Server,
      {:hide_guess, socket, gameName, load(gameName)},
      1000
    )
  end
end
