# https://adventofcode.com/2022/day/3

defmodule Solution do
  def get_alphabets_dict() do
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    |> String.split("", trim: true)
    |> Enum.reduce(%{}, fn
      x, acc ->
        Map.put(acc, x, Enum.count(acc)+1)
    end)
  end

  def run(file, part) do
    {_, res} = File.read(file)
    alpha_dict = get_alphabets_dict()
    processed_list = res
      |> String.split("\n", trim: true)

    case part do
      :one ->
        processed_list
          |> Enum.map(fn x ->
            strlen = round(String.length(x)/2)
            [String.split(String.slice(x, 0..strlen-1), "", trim: true), String.split(String.slice(x, strlen..-1//1), "", trim: true)]
          end)
          |> Enum.map(fn [a, b] -> Enum.at(MapSet.to_list(MapSet.intersection(MapSet.new(a), MapSet.new(b))), 0) end)
          |> Enum.map(fn x -> Map.get(alpha_dict, x) end)
          |> Enum.reduce(0, fn x, acc -> x + acc end)
      :two ->
        processed_list
          |> Enum.map(fn x -> String.split(x, "", trim: true) end)
          |> Enum.chunk_every(3)
          |> Enum.map(fn [a, b, c] -> Enum.at(MapSet.to_list(MapSet.intersection(MapSet.intersection(MapSet.new(a), MapSet.new(b)), MapSet.new(c))), 0) end)
          |> Enum.map(fn x -> Map.get(alpha_dict, x) end)
          |> Enum.reduce(0, fn x, acc -> x + acc end)
    end
  end
end

IO.inspect(Solution.run("./inputs/day_3.txt", :one))
IO.inspect(Solution.run("./inputs/day_3.txt", :two))
