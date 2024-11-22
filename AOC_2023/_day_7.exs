# https://adventofcode.com/2023/day/6

defmodule Solution do
  def map_maintainer( element, count_map) do
    cond do
      Map.has_key?(count_map, element) ->
        Map.put(count_map, element, Map.get(count_map, element)+1)
      true ->
        Map.put(count_map, element, 1)
    end
  end

  def calc_repetitions(ref_list) do
    Enum.reduce(ref_list, %{}, &map_maintainer/2)
  end

  def calculate_type(hand) do
    # Five of a kind, where all five cards have the same label: AAAAA
    # Four of a kind, where four cards have the same label and one card has a different label: AA8AA
    # Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
    # Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
    # Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
    # One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
    # High card,  where all cards' labels are distinct: 23456

  end

  def calculate_priority(hand) do
    split_hand = String.split(hand, "", trim: true)
  end

  def run() do
    {_, res} = File.read('./inputs/day_7.txt')

    full_list =
      res
      |> String.split("\n", trim: true)
      |> Enum.to_list()
      |> Enum.map(fn x -> String.split(x, " ", trim: true) end)
      |> Enum.map(fn [seq, val] -> [calculate_priority(seq), val] end)
      |> Enum.map(fn [seq_list, val] -> [calc_repetitions(seq_list), val] end)

      # calculate_priority(full_list)
  end
end

IO.inspect(Solution.run())
