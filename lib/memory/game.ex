defmodule Memory.Game do
  # TODO is there a better way to update?
  use MemoryWeb, :channel
  alias Memory.MemoryAgent

  def new() do
    %{
      clickCount: 0,
      isSecondClick: false,
      prevItemProps: nil,
      isEnabled: true,
      itemPropsMap: newPropsMap()
    }
  end

  def handleItemClick(itemProps, gameState, socket) do
    # TODO set a timer to broadcast the game enabled state after a delay
    prevProps = gameState["prevItemProps"]
    clickCount = gameState["clickCount"]
    itemProps = Map.put(itemProps, "isHidden", false)
    gameState = Map.put(gameState, "clickCount", clickCount + 1)
    gameState = updateItem(itemProps, gameState)
    MemoryAgent.save("foo", %{gameState: gameState, itemProps: itemProps})
    broadcast!(socket, "update", gameState)
    # TODO TODO TODO
    MemoryAgent.load("foo") |> IO.inspect()

    if gameState["isSecondClick"] do
      IO.inspect(itemProps["value"])
      IO.inspect(prevProps["value"])

      gameState =
        if itemProps["value"] == prevProps["value"] do
          itemProps = Map.put(itemProps, "isMatched", true)
          prevProps = Map.put(prevProps, "isMatched", true)
          gameState = updateItem(itemProps, gameState)
          gameState = updateItem(prevProps, gameState)
          MemoryAgent.save("foo", %{gameState: gameState, itemProps: itemProps})
          broadcast!(socket, "update", gameState)
          # TODO TODO TODO
          MemoryAgent.load("foo") |> IO.inspect()
          gameState
        else
          gameState = Map.put(gameState, "isEnabled", false)
          MemoryAgent.save("foo", %{gameState: gameState, itemProps: itemProps})
          broadcast!(socket, "update", gameState)
          # TODO TODO TODO
          MemoryAgent.load("foo") |> IO.inspect()
          gameState
        end
    end

    gameState = Map.put(gameState, "prevProps", itemProps)
    gameState = Map.put(gameState, "isSecondClick", !gameState["isSecondClick"])
    MemoryAgent.save("foo", %{gameState: gameState, itemProps: itemProps})
    broadcast!(socket, "update", gameState)
    # TODO TODO TODO
    MemoryAgent.load("foo") |> IO.inspect()
    gameState
  end

  # update the isEnabled flag for each item
  def updateEnabled(gameState) do
    IO.puts("UPDATE ENABLED ...")
    propsMap = gameState["itemPropsMap"]
    updatedProps = %{}

    Enum.each(propsMap, fn {id, prop} ->
      prop = Map.put(prop, "isEnabled", gameState["isEnabled"])
      updatedProps = Map.put(updatedProps, id, prop)
    end)

    Map.put(gameState, "itemPropsMap", updatedProps)
  end

  # updates an item and returns a new game state
  def updateItem(itemProps, gameState) do
    propsMap = gameState["itemPropsMap"]
    propsMap = Map.put(propsMap, itemProps["id"], itemProps)
    Map.put(gameState, "itemPropsMap", propsMap)
  end

  def handleGameReset() do
    new()
  end

  defp newPropsMap() do
    newLetterArray() |> newPropsMap(15, %{})
  end

  defp newLetterArray() do
    ~w(A B C D E F G H A B C D E F G H) |> Enum.shuffle()
  end

  defp newPropsMap(letters, countdown, acc) do
    if countdown < 0 do
      acc
    else
      [val | letters] = letters

      acc =
        Map.put_new(acc, "#{countdown}", %{
          id: countdown,
          isEnabled: true,
          isHidden: true,
          isMatched: false,
          value: val
        })

      newPropsMap(letters, countdown - 1, acc)
    end
  end
end
