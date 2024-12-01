 # https://adventofcode.com/2022/day/4

defmodule Solution do
  def stack_push(stack, element) do
    element ++ stack
  end

  def stack_pop(stack, count, problemset) do
    case problemset do
      :one ->
        {Enum.reverse(Enum.take(stack, count)), Enum.take(stack, count - Enum.count(stack))}
      :two ->
        {Enum.take(stack, count), Enum.take(stack, count - Enum.count(stack))}
    end
  end

  def add_to_dict(dict, key, value) do
    cond do
      Map.has_key?(dict, key) ->
        Map.put(dict, key, value)
      true ->
        Map.put(dict, key, value)
    end
  end

  def transpose(m) do
    List.zip(m) |> Enum.map(&Tuple.to_list(&1))
  end

  def process_move([count, from, to], crate_stacks, problemset) do
    {count_int, _} = Integer.parse(count)
    {taken_from, updated_from} = stack_pop(Map.get(crate_stacks, from), count_int, problemset)
    # IO.inspect(count <> "  " <> from <> "  " <> to)
    # IO.inspect(crate_stacks)
    # IO.inspect(taken_from)
    # IO.inspect(updated_from)
    updated_to = stack_push(Map.get(crate_stacks, to), taken_from)
    nmap = Map.put(crate_stacks, from, updated_from)
    updated_map = Map.put(nmap, to, updated_to)
    # IO.inspect(updated_map)
    updated_map
  end

  def run(file, part) do
    {_, res} = File.read(file)

    processed_content = res
      |> String.split("\n\n", trim: true)

    crates = Enum.at(processed_content, 0)
    moves = Enum.at(processed_content, 1)

    crate_stacks = String.split(crates, "\n", trim: true)
      |> Enum.map(fn x -> String.split(String.slice(x, 1..-1//1), "", trim: true) end)
      |> Enum.map(fn x ->
          Enum.take_every(x, 2)
        end
      )
      |> Enum.map(fn x ->
          Enum.take_every(x, 2)
        end
      )
      |> transpose()
      |> Enum.map(fn y -> Enum.filter(y, fn x -> x != " " end) end)
      |> Enum.reduce(%{}, fn x, acc ->
            Map.put(acc, Enum.at(x, -1), Enum.slice(x, 0..-2//1))
        end
      )

    String.split(moves, "\n", trim: true)
      |> Enum.map(fn x -> String.split(x, " ", trim: true) end)
      |> Enum.map(fn x -> [Enum.at(x, 1), Enum.at(x, 3), Enum.at(x, 5)] end)
      |> Enum.reduce(crate_stacks, fn x, acc -> process_move(x, acc, part) end)
      |> Enum.sort(fn {x, _}, {y, _} -> Integer.parse(x) <= Integer.parse(y) end)
      |> Enum.reduce("", fn {_, x}, acc -> acc <> Enum.at(x, 0) end)

  end
end

IO.inspect(Solution.run("./inputs/day_5.txt", :one))
IO.inspect(Solution.run("./inputs/day_5.txt", :two))
