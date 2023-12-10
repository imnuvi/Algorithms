# https://adventofcode.com/2023/day/9

defmodule Solution do
  def generate_diff_list(line) do
    %{:ans => ans} =
      Enum.slice(line, 1..-1)
      |> Enum.reduce(
        %{:curr => Enum.at(line, 0), :ans => []},
        fn x, %{:curr => curr, :ans => ans} ->
          %{:curr => x, :ans => ans ++ [x - curr]}
        end
      )

    ans
  end

  def calculate_line(line, part) do
    diff_list = generate_diff_list(line)

    cond do
      Enum.all?(diff_list, fn x -> x == 0 end) ->
        case part do
          :one ->
            line_num = Enum.at(line, -1)
            line_num + 0

          :two ->
            line_num = Enum.at(line, 0)
            line_num + 0
        end

      true ->
        case part do
          :one ->
            line_num = Enum.at(line, -1)
            line_num + calculate_line(diff_list, part)

          :two ->
            line_num = Enum.at(line, 0)
            line_num - calculate_line(diff_list, part)
        end
    end
  end

  def run(part) do
    {_, res} = File.read('./inputs/day_9.txt')

    res
    |> String.split("\n", trim: true)
    |> Enum.to_list()
    |> Enum.map(fn x ->
      x
      |> String.split(" ", trim: true)
      |> Enum.map(fn y -> String.to_integer(y) end)
    end)
    |> Enum.map(fn x -> calculate_line(x, part) end)
    |> Enum.reduce(fn x, acc -> x + acc end)
  end
end

IO.inspect(Solution.run(:one))
IO.inspect(Solution.run(:two))
