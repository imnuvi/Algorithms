# https://adventofcode.com/2023/day/6

defmodule Solution do
  def run() do
    {_, res} = File.read('./inputs/day_7.txt')

    full_list =
      res
      |> String.split("\n", trim: true)
      |> Enum.to_list()
  end
end

IO.inspect(Solution.run())
