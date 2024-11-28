# https://adventofcode.com/2022/day/4

defmodule Solution do
  def determine_subset([set1, set2]) do
    MapSet.subset?(set1, set2) or MapSet.subset?(set2, set1)
  end

  def determine_disjoint([set1, set2]) do
    MapSet.disjoint?(set1, set2)
  end

  def run(file, part) do
    {_, res} = File.read(file)

    processed_list = res
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.split(x, ",", trim: true) end)
      |> Enum.map(fn [x, y] -> [String.split(x, "-", trim: true), String.split(y, "-", trim: true)] end)
      |> Enum.map(fn [[i1, i2], [j1, j2]] ->
        {ni1, _} = Integer.parse(i1)
        {ni2, _} = Integer.parse(i2)
        {nj1, _} = Integer.parse(j1)
        {nj2, _} = Integer.parse(j2)
        [[ni1, ni2], [nj1, nj2]]
      end)
      |> Enum.map(fn [[i1, i2], [j1, j2]] -> [Enum.to_list(i1..i2), Enum.to_list(j1..j2)] end)
      |> Enum.map(fn [x, y] -> [MapSet.new(x), MapSet.new(y)] end)

    case part do
      :one ->
        processed_list
          |> Enum.map(&determine_subset/1)
          |> Enum.count(& &1 == :true)
      :two ->
        processed_list
          |> Enum.map(&determine_disjoint/1)
          |> Enum.count(& &1 == :false)
    end
  end
end

IO.inspect(Solution.run("./inputs/day_4.txt", :one))
IO.inspect(Solution.run("./inputs/day_4.txt", :two))
