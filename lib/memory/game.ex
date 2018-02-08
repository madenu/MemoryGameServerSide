defmodule Memory.Game do

  def new() do
    %{
      clickCount: 0,
      isSecondClick: false,
      prevItemProps: nil,
      isEnabled: true,
      itemPropsMap: newPropsMap()
      }
  end

  def newPropsMap() do
    newPropsMap(15, %{})
  end

  defp newPropsMap(countdown, acc) do
    if countdown < 0 do
      acc
    else
      acc = Map.put_new(acc, "#{countdown}",
       %{id: countdown,
        isEnabled: true,
        isHidden: true,
        isMatched: false,
        value: ""})
      newPropsMap(countdown - 1, acc)
    end
  end
end
