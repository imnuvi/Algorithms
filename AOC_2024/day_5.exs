# https://adventofcode.com/2024/day/5

defmodule Solution do
  def check_validity(order, forward_rules, reverse_rules) do
    middle_index = div(length(order), 2)
    middle_value = Enum.at(order, middle_index)
    validity = Enum.with_index(order, fn x, index ->
      {head, tail} = Enum.split(order, index)
      {_, tail} = Enum.split(tail, 1)

      headset = MapSet.new(head)
      tailset = MapSet.new(tail)

      forwardset = MapSet.new(Map.get(forward_rules, x, []))
      reverseset = MapSet.new(Map.get(reverse_rules, x, []))

      # forward check
      forcheck = MapSet.disjoint?(forwardset, headset)
      # reverse check
      revcheck = MapSet.disjoint?(reverseset, tailset)

      # IO.inspect(tailset)
      # IO.inspect(forwardset)
      # IO.inspect(reverseset)
      # IO.inspect(headset)
      # IO.puts(" --------")
      (forcheck and revcheck)
    end)
    {validity, middle_value}
    # Enum.all?(order, fn [x | tail] -> x end)
  end

  def run(file, part) do
    {_, res} = File.read(file)

    processed = res
      |> String.split("\n\n", trim: true)

    {forward_rules, reverse_rules} = Enum.at(processed, 0)
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.split(x, "|", trim: true) end)
      |> Enum.reduce({%{}, %{}}, fn [prev, next], {forward_rules, reverse_rules} -> {Map.put(forward_rules, prev, Map.get(forward_rules, prev, []) ++ [next] ), Map.put(reverse_rules, next, Map.get(reverse_rules, next, []) ++ [prev] )} end)
    printing = Enum.at(processed, 1)
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.split(x, ",", trim: true) end)

    case part do
      :one ->
        printing
          |> Enum.map(fn x -> check_validity(x, forward_rules, reverse_rules) end)
          |> Enum.filter(fn {validity, _y} -> Enum.all?(validity) end)
          |> Enum.reduce(0, fn {_, y}, acc ->
            {parsed, _} = Integer.parse(y)
            acc + parsed
          end)
        # printing
      :two ->
        {forward_rules, reverse_rules}
        :pass
    end
  end
end

IO.inspect(Solution.run("./inputs/day_5.txt", :one))
IO.inspect(Solution.run("./inputs/day_5.txt", :two))

# IO.inspect(Solution.check_validity([1,1,2,3,3], %{}, %{}))
