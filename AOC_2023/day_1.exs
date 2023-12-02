# https://adventofcode.com/2023/day/1
# The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover. On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.

defmodule Solution do
  def read_nums(line) do
    reg_res = Regex.scan(~r/[0-9]/, line)
    String.to_integer(Enum.at(Enum.at(reg_res, 0), 0) <> Enum.at(Enum.at(reg_res, -1), 0))
  end

  def convert_char(char) do
    charl = %{
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"
    }

    Map.get(charl, char, char)
  end

  def read_nums_chars(line) do
    reg_res =
      Regex.scan(
        ~r/(?=(one|two|three|four|five|six|seven|eight|nine|[0-9]))/,
        line
      )

    String.to_integer(
      convert_char(Enum.at(Enum.at(reg_res, 0), -1)) <>
        convert_char(Enum.at(Enum.at(reg_res, -1), -1))
    )
  end

  def run_part_one() do
    {_, res} = File.read('./inputs/day_1.txt')

    lines =
      res
      |> String.split("\n", trim: true)
      |> Enum.to_list()

    Enum.reduce(lines, 0, fn x, acc -> acc + read_nums(x) end)
  end

  def run_part_two() do
    {_, res} = File.read('./inputs/day_1.txt')

    lines =
      res
      |> String.split("\n", trim: true)
      |> Enum.to_list()

    Enum.reduce(lines, 0, fn x, acc -> acc + read_nums_chars(x) end)
  end
end

IO.puts(Solution.run_part_one())
IO.puts(Solution.run_part_two())
