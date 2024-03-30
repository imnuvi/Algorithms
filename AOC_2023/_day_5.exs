# https://adventofcode.com/2023/day/5

defmodule Solution do
  def run() do
    {_, res} = File.read('./inputs/day_5.txt')

    full_list = res
      |> String.split("\n\n", trim: true)
      |> Enum.to_list()
      |> Enum.each(fn x -> IO.puts(x) end)
      # |> String.split("\n", trim: true)
      # |> Enum.to_list()

    # cases = Enum.take(full_list, 1)
    # chunks = Enum.take(full_list, 1)
  end
end

IO.puts(Solution.run())
