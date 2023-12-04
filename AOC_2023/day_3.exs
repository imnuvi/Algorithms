# https://adventofcode.com/2023/day/3

# The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

defmodule Solution do
  def validate_adjacent(adjacency_list) do
    regex_res = Regex.scan(~r/[^a-z0-9.]/, adjacency_list)

    cond do
      length(regex_res) == 0 ->
        false

      true ->
        true
    end
  end

  def calc_within(line, matches, start_ix, cur_ix, end_ix) do
    Enum.reduce(matches, [], fn match, acc ->
      [{cur_start, len}] = match

      cond do
        start_ix in cur_start..(cur_start + len - 1) || end_ix in cur_start..(cur_start + len - 1) ||
            cur_ix in cur_start..(cur_start + len - 1) ->
          acc ++
            [String.to_integer(String.slice(line, cur_start..(cur_start + len - 1)))]

        true ->
          acc
      end
    end)
  end

  def acquire_adjacent_list(prev_line, line, next_line, start_ix, cur_ix, end_ix) do
    prev_regex_res = Regex.scan(~r/[0-9]+/, prev_line, return: :index)
    cur_regex_res = Regex.scan(~r/[0-9]+/, line, return: :index)
    next_regex_res = Regex.scan(~r/[0-9]+/, next_line, return: :index)

    adjacent_list =
      calc_within(prev_line, prev_regex_res, start_ix, cur_ix, end_ix) ++
        calc_within(line, cur_regex_res, start_ix, cur_ix, end_ix) ++
        calc_within(next_line, next_regex_res, start_ix, cur_ix, end_ix)

    cond do
      length(adjacent_list) == 2 ->
        Enum.at(adjacent_list, 0) * Enum.at(adjacent_list, -1)

      true ->
        0
    end
  end

  def parse_2(prev_line, line, next_line) do
    # this operates on strings
    matches = Regex.scan(~r/\*/, line, return: :index)

    Enum.reduce(matches, 0, fn match, acc ->
      [{start_i, _len}] = match
      acc + acquire_adjacent_list(prev_line, line, next_line, start_i - 1, start_i, start_i + 1)
    end)
  end

  def parse(prev_line, line, next_line) do
    # this operates on strings
    matches = Regex.scan(~r/[0-9]+/, line, return: :index)

    Enum.reduce(matches, 0, fn match, acc ->
      [{start_i, len}] = match
      og_start = if start_i == 0, do: 0, else: start_i - 1

      curval = String.to_integer(String.slice(line, start_i..(start_i + len - 1)))

      lstr = String.slice(prev_line, og_start..(start_i + len))
      rstr = String.slice(next_line, og_start..(start_i + len))
      curstr = String.slice(line, og_start..(start_i + len))

      cond do
        validate_adjacent(lstr <> rstr <> curstr) ->
          acc + curval

        true ->
          acc
      end
    end)
  end

  def pass_lists(lines, index) do
    empty_list = String.duplicate(".", length(lines))

    cond do
      index == 0 ->
        parse(empty_list, Enum.at(lines, index), Enum.at(lines, index + 1))

      index == length(lines) - 1 ->
        parse(Enum.at(lines, index - 1), Enum.at(lines, index), empty_list)

      true ->
        parse(Enum.at(lines, index - 1), Enum.at(lines, index), Enum.at(lines, index + 1))
    end
  end

  def pass_lists_two(lines, index) do
    empty_list = String.duplicate(".", length(lines))

    cond do
      index == 0 ->
        parse_2(empty_list, Enum.at(lines, index), Enum.at(lines, index + 1))

      index == length(lines) - 1 ->
        parse_2(Enum.at(lines, index - 1), Enum.at(lines, index), empty_list)

      true ->
        parse_2(Enum.at(lines, index - 1), Enum.at(lines, index), Enum.at(lines, index + 1))
    end
  end

  def run(part) do
    {_, res} = File.read('./inputs/day_3.txt')

    lines =
      res
      |> String.split("\n", trim: true)
      |> Enum.to_list()

    case part do
      :one ->
        Enum.reduce(0..(length(lines) - 1), 0, fn x, acc -> acc + pass_lists(lines, x) end)

      :two ->
        Enum.reduce(0..(length(lines) - 1), 0, fn x, acc -> acc + pass_lists_two(lines, x) end)
    end
  end
end

IO.inspect(Solution.run(:one))
IO.inspect(Solution.run(:two))
