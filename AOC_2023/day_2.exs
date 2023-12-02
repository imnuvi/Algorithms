# https://adventofcode.com/2023/day/2

defmodule Solution do
  def put_case(str, end_map) do
    [count, colour] = String.split(String.trim(str), " ")
    count = String.to_integer(count)
    end_map = Map.put(end_map, "sum", Map.get(end_map, "sum") + count)

    cond do
      Map.has_key?(end_map, colour) ->
        cur_count = Map.get(end_map, colour)
        Map.put(end_map, colour, cur_count + count)

      true ->
        Map.put(end_map, colour, count)
    end
  end

  def convert_map(act_case) do
    full_case = String.split(act_case, ",")
    Enum.reduce(full_case, %{"sum" => 0}, &put_case/2)
  end

  def get_testcase() do
    %{"red" => 12, "green" => 13, "blue" => 14, "sum" => 12 + 13 + 14}
  end

  def get_empty() do
    %{"red" => 0, "green" => 0, "blue" => 0}
  end

  def compare({cur_colour, cur_value}) do
    test_map = get_testcase()

    cond do
      Map.get(test_map, cur_colour) >= cur_value ->
        false

      true ->
        true
    end
  end

  def compare_show(sep_show) do
    show_map = convert_map(sep_show)

    Enum.any?(show_map, fn x -> compare(x) end)
  end

  def check_valid(line) do
    [test_case_line, act_line] = String.split(line, ":")
    test_case = String.to_integer(Enum.at(String.split(test_case_line, " "), -1))
    sep_test_cases = String.split(act_line, ";")

    cond do
      Enum.any?(sep_test_cases, fn x -> compare_show(x) end) ->
        0

      true ->
        test_case
    end
  end

  def map_max({cur_colour, cur_value}, acc) do
    old_val = Map.get(acc, cur_colour)

    cond do
      cur_value > old_val ->
        Map.put(acc, cur_colour, cur_value)

      true ->
        acc
    end
  end

  def calc_power(curr, acc) do
    show_map = convert_map(curr)
    Enum.reduce(show_map, acc, &map_max/2)
  end

  def multiply_stuff(my_map) do
    Enum.reduce(my_map, 1, fn {_, val}, acc -> val * acc end)
  end

  def check_valid_p2(line) do
    [_, act_line] = String.split(line, ":")
    sep_test_cases = String.split(act_line, ";")
    multiply_stuff(Enum.reduce(sep_test_cases, get_empty(), &calc_power/2))
  end

  def run(part) do
    {_, res} = File.read('./inputs/day_2.txt')

    lines =
      res
      |> String.split("\n", trim: true)
      |> Enum.to_list()

    case part do
      :one ->
        Enum.reduce(lines, 0, fn x, acc -> check_valid(x) + acc end)

      :two ->
        Enum.reduce(lines, 0, fn x, acc -> check_valid_p2(x) + acc end)
    end
  end
end

IO.puts(Solution.run(:one))
IO.puts(Solution.run(:two))
