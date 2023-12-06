# https://adventofcode.com/2023/day/4#part2

defmodule Solution do
  def format_line(line) do
    [_card, record] = String.split(line, ":")
    [winning_cards, scratched_cards] = String.split(record, "|")

    winning_list = Regex.scan(~r/[0-9]+/, winning_cards)
      |> List.flatten

    Regex.scan(~r/[0-9]+/, scratched_cards)
      |> List.flatten
      |> Enum.map(fn x -> Enum.member?(winning_list, x) end)
      |> Enum.filter(fn x -> x end)
      |> Enum.count()
  end

  def forward_calculator(line, {total, count_map}) do

    [card, _] = String.split(line, ":")

    matches = format_line(line)

    parsed_card_no = String.trim(card)
      |> String.split( " ")
      |> Enum.at(-1)
      |> String.to_integer()
    mul_factor = Map.get(count_map, parsed_card_no, 1)

    case matches do
      0 ->
        {total + mul_factor, count_map}
      _ ->
      count_map = Enum.reduce(parsed_card_no+1..parsed_card_no + matches,
          count_map,
          fn x, acc ->
            Map.put(acc, x, Map.get(acc, x, 1) + mul_factor)
          end
        )
        {total + mul_factor, count_map}
    end
  end

  def run(part) do
    {_, res} = File.read('./inputs/day_4.txt')

    case part do
    :one -> res
      |> String.split("\n", trim: true)
      |> Enum.to_list()
      |> Enum.map(&format_line/1)
      |> Enum.filter(fn x -> x>0 end)
      |> Enum.reduce(0, fn x, acc -> (2 ** (x-1)) + acc end)
    :two ->
      {ans, _resdict} = res
      |> String.split("\n", trim: true)
      |> Enum.to_list()
      |> Enum.reduce({0, %{}}, fn x, acc -> forward_calculator(x, acc) end)
      ans
    end
  end

end

IO.inspect(Solution.run(:one))
IO.inspect(Solution.run(:two))
