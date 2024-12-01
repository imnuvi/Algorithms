# https://adventofcode.com/2024/day/1

defmodule Solution do
  def transpose(m) do
    List.zip(m) |> Enum.map(&Tuple.to_list(&1))
  end

  def run(file, part) do
    {_, res} = File.read(file)

    processed_content = res
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.split(x, "   ", trim: true) end)

    trans =
      transpose(processed_content)
      |> Enum.map(fn x -> Enum.map(x, fn y -> Integer.parse(y) end ) end)
      |> Enum.map(fn x -> Enum.sort(Enum.map(x, fn {y, _} -> y end )) end)

    Enum.zip(Enum.at(trans, 0), Enum.at(trans, -1))
      |> Enum.reduce(0, fn x, acc -> acc + abs(elem(x, 0) - elem(x, 1)) end)

  end
end

IO.inspect(Solution.run("./inputs/day_1.txt", :one))
IO.inspect(Solution.run("./inputs/day_1.txt", :two))
