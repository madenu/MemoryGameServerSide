defmodule Memory.Game do
  use MemoryWeb, :channel
  alias Memory.MemoryAgent

  def rejoin(gameName) do
    gS =
      if MemoryAgent.load(gameName) do
        %{gameState: temp, itemProps: _iP} = MemoryAgent.load(gameName)
        temp
      else
        temp = new()
        MemoryAgent.save(gameName, %{gameState: temp, itemProps: nil})
        temp
      end
  end

  def new() do
    %{
      "clickCount" => 0,
      "isSecondClick" => false,
      "prevItemProps" => nil,
      "isEnabled" => true,
      "itemPropsMap" => newPropsMap()
    }
  end

  def handleItemClick(gameName, itemProps, gameState, socket) do
    prevProps = gameState["prevItemProps"]
    clickCount = gameState["clickCount"]
    newProps = Map.put(itemProps, "isHidden", false)
    newState = Map.put(gameState, "clickCount", clickCount + 1)
    newState = updateItem(newProps, newState)
    MemoryAgent.save(gameName, %{gameState: newState, itemProps: newProps})

    if newState["isSecondClick"] do
      if newProps["value"] == prevProps["value"] do
        newProps = Map.put(newProps, "isMatched", true)
        prevProps = Map.put(prevProps, "isMatched", true)
        newState = Map.put(newState, "isSecondClick", !newState["isSecondClick"])
        newState = updateItem(newProps, newState)
        newState = updateItem(prevProps, newState)
        MemoryAgent.save(gameName, %{gameState: newState, itemProps: newProps})
        newState
      else
        newState = Map.put(newState, "isEnabled", false)
        newState = updateEnabled(newState)
        MemoryAgent.save(gameName, %{gameState: newState, itemProps: newProps})
        MemoryAgent.schedule_work(%{name: gameName, socket: socket})
        newState
      end
    else
      newState = Map.put(newState, "prevItemProps", newProps)
      newState = Map.put(newState, "isSecondClick", !newState["isSecondClick"])
      MemoryAgent.save(gameName, %{gameState: newState, itemProps: newProps})
      newState
    end
  end

  # update the isEnabled flag for each item
  def updateEnabled(gameState) do
    propsMap = gameState["itemPropsMap"]
    updatedProps = helpUpdateEnabled(15, propsMap, gameState["isEnabled"])
    Map.put(gameState, "itemPropsMap", updatedProps)
  end

  # recurs through all of the item IDs, disabling or enabling them according to the flag
  defp helpUpdateEnabled(id, propsMap, flag) do
    if id < 0 do
      propsMap
      IO.inspect(propsMap)
    else
      updated = Map.put(propsMap, "#{id}", Map.put(propsMap["#{id}"], "isEnabled", flag))
      helpUpdateEnabled(id - 1, updated, flag)
    end
  end

  # updates an item and returns a new game state
  def updateItem(itemProps, gameState) do
    propsMap = gameState["itemPropsMap"]
    propsMap = Map.put(propsMap, itemProps["id"], itemProps)
    Map.put(gameState, "itemPropsMap", propsMap)
  end

  def handleGameReset(gameName) do
    MemoryAgent.save(gameName, %{gameState: new(), itemProps: nil})
    %{gameState: gS, itemProps: _iP} = MemoryAgent.load(gameName)
    gS
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
          "id" => countdown,
          "isEnabled" => true,
          "isHidden" => true,
          "isMatched" => false,
          "value" => val
        })

      newPropsMap(letters, countdown - 1, acc)
    end
  end
end
