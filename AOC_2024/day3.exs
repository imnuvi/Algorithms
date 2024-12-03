# https://adventofcode.com/2024/day/3

defmodule Solution do
  def process_matches(match_list) do
    parsed_and_procd = Enum.map(match_list, fn [_, x] -> String.split(x, ",", trim: true) end)
    Enum.map(parsed_and_procd, fn [x, y] ->
      {parsedx, _} = Integer.parse(x)
      {parsedy, _} = Integer.parse(y)
      parsedx * parsedy
    end)
    |> Enum.sum()
  end

  def run(file, part) do
        {_, res} = File.read(file)

        regex = ~r"mul\((\d+,\d+?)\)"
        operand_regex = ~r"don\'t\(\).*?(do\(\)|$)"

        processed = res
          |> String.split("\n", trim: true)


        case part
        do
          :one ->
            processed
            |> Enum.map(fn x -> Regex.scan(regex, x) end)
            |> Enum.map(fn x -> process_matches(x) end)
            |> Enum.sum()
          :two ->
            processed
              |> Enum.map(fn x -> Regex.replace(operand_regex, x, "") end)
              |> Enum.map(fn x -> Regex.scan(regex, x) end)
              |> Enum.map(fn x -> process_matches(x) end)
              |> Enum.sum()
        end
      end
end

IO.inspect(Solution.run("./inputs/day_3.txt", :one))
IO.inspect(Solution.run("./inputs/day_3.txt", :two))
