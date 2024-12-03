# https://adventofcode.com/2024/day/2

defmodule Solution do
  def check_safety(safety_list, mindiff) do
      chunker = Enum.chunk_every(safety_list, 2, 1, :discard)
      Enum.all?(Enum.map(chunker, fn [v1, v2] -> (v1 > v2) and (abs(v1 - v2) <= mindiff) end)) or Enum.all?(Enum.map(chunker, fn [v1, v2] -> (v1 < v2) and (abs(v1 - v2) <= mindiff) end))
  end

  def run(file, part) do
    {_, res} = File.read(file)
    mindiff = 3

    processed = res
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.split(x, " ", trim: true)  end)
      |> Enum.map(fn x -> Enum.map(x, fn y ->
        {parsed, _} = Integer.parse(y)
          parsed
        end
        )
      end)

    case part do
      :two ->
        processed
          |> Enum.map(fn y ->
             Enum.map(y, fn x -> check_safety(List.delete(y, x), mindiff) end )
          end)
          |> Enum.map(fn x -> Enum.any?(x) end )
          |> Enum.count(fn x -> x == true end)

      :one ->
        processed
          # |> Enum.map(fn x -> Enum.chunk_every(x, 2, 1, :discard) end)
          # |> Enum.map(fn x -> [Enum.map(x, fn [v1, v2] -> (v1 > v2) and (abs(v1 - v2) <= mindiff) end), Enum.map(x, fn [v1, v2] -> (v1 < v2) and (abs(v1 - v2) <= mindiff) end)] end)
          # |> Enum.map(fn [l1, l2] -> Enum.all?(l1) or Enum.all?(l2) end )
          |> Enum.map(fn x -> check_safety(x, mindiff) end)
          |> Enum.count(fn x -> x == true end)
    end
  end
end

IO.inspect(Solution.run("./inputs/day_2.txt", :one))
# Solution.run("./inputs/day_2.txt", :one)
IO.inspect(Solution.run("./inputs/day_2.txt", :two))
