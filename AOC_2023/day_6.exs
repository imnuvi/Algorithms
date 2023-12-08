# https://adventofcode.com/2023/day/6

defmodule Solution do
  def calculate_movement(time, max_time) do
    (max_time - time) * time
  end

  def calculate_press(max_time) do
    1..max_time
    |> Enum.map(fn x -> calculate_movement(x, max_time) end)
  end

  def calculate_wins(cur, acc) do
    {max_time, distance} = cur

    counts =
      1..max_time
      |> Enum.map(fn x -> calculate_movement(x, max_time) end)
      |> Enum.filter(fn x -> x > distance end)
      |> Enum.count()

    IO.inspect(counts)
    acc * counts
  end

  def map_part(lss, :one) do
    Enum.map(lss, fn x -> String.to_integer(x) end)
  end

  def map_part(lss, :two) do
    [String.to_integer(Enum.join(lss, ""))]
  end

  def run(part) do
    {_, res} = File.read('./inputs/day_6.txt')

    full_list =
      res
      |> String.split("\n", trim: true)
      |> Enum.to_list()
      |> Enum.map(fn x ->
        String.split(x, " ", trim: true)
        |> Enum.slice(1..-1)
        |> map_part(part)
      end)

    [time, distance] = full_list

    dmap =
      Enum.reduce(0..(Enum.count(time) - 1), %{}, fn x, acc ->
        Map.put(acc, Enum.at(time, x), Enum.at(distance, x))
      end)

    Enum.reduce(dmap, 1, &calculate_wins/2)
  end
end

IO.inspect(Solution.run(:one))
IO.inspect(Solution.run(:two))
