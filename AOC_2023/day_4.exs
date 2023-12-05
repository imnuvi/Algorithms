



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
      # |> Enum.reduce(1, fn x -> )
      |> Enum.count()
      # |> Enum.each(&String.to_integer/1)
      # |> Enum.map(fn x ->
      #     {_, re} = Regex.compile(x)
      #     re
      #   end)
      # |> Enum.map(&IO.inspect/1)
      # |> Enum.map(fn x ->
      #   Regex.run(x, winning_cards)
      #   end)

    # IO.inspect(scan)
    # splitted
  end

  def run() do
    {_, res} = File.read('./inputs/day_4.txt')

      res
      |> String.split("\n", trim: true)
      |> Enum.to_list()
      |> Enum.map(&format_line/1)
      |> Enum.filter(fn x -> x>0 end)
      |> Enum.reduce(0, fn x, acc -> (2 ** (x-1)) + acc end)

  end

end


IO.inspect(Solution.run())
