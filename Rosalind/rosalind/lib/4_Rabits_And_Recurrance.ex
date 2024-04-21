# https://rosalind.info/problems/fib/

defmodule RabbitsAndRecurrance do
  def extend_list(init, mult) do
    init ++ [Enum.at(init, Enum.count(init) - 1) + Enum.at(init, Enum.count(init) - 2) * mult]
  end

  def call_recurse(rec_list, mult, count, curr) do
    # IO.inspect(rec_list)

    cond do
      curr >= count ->
        extend_list(rec_list, mult)

      true ->
        call_recurse(extend_list(rec_list, mult), mult, count, curr + 1)
    end
  end

  def run(input) do
    [n, k] = Enum.map(String.split(input, " ", trim: true), fn x -> String.to_integer(x) end)
    init = [1, 1]
    r_list = call_recurse(init, k, n - 3, 0)

    Enum.at(r_list, Enum.count(r_list) - 1)
  end
end

{_, file} = File.read("./lib/inputs/4_Rabbits_And_Recurrance.txt")
IO.inspect(RabbitsAndRecurrance.run(file))
