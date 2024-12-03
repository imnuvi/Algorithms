
defmodule Solution do
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
      |> Enum.map(fn x -> Enum.chunk_every(x, 2, 1, :discard) end)
      |> Enum.map(fn x -> [Enum.map(x, fn [v1, v2] -> (v1 > v2) and (abs(v1 - v2) <= mindiff) end), Enum.map(x, fn [v1, v2] -> (v1 < v2) and (abs(v1 - v2) <= mindiff) end)] end)

    case part do
      :one ->
        processed
          |> Enum.map(fn [l1, l2] -> Enum.all?(l1) or Enum.all?(l2) end )
          |> Enum.count(fn x -> x == true end)

      :two ->
        processed
          |> Enum.map(fn [l1, l2] -> Enum.all?(l1) or Enum.all?(l2) or Enum.count(l1, fn x -> x == false end) == 1  or Enum.count(l2, fn x -> x == false end) == 1 end )
          |> Enum.count(fn x -> x == true end)
    end
  end
end

IO.inspect(Solution.run("./inputs/day_2.txt", :one))
IO.inspect(Solution.run("./inputs/day_2.txt", :two))
