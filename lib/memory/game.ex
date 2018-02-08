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

  def handleItemClick(payload) do
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
          # isHidden: true, TODO
          isHidden: false,
          isMatched: false,
          value: val
        })

      newPropsMap(letters, countdown - 1, acc)
    end
  end
end
