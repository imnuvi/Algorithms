# https://rosalind.info/problems/fib/

defmodule Solution do
  def extend_list(init, mult, babies) do
    cond do
      Enum.count(babies) >= mult ->
        {init ++
           [
             Enum.at(init, Enum.count(init) - 1) + Enum.at(babies, Enum.count(init) - 1) -
               Enum.at(babies, Enum.count(babies) - mult)
           ], babies ++ [Enum.at(init, Enum.count(init) - 1)]}

      true ->
        {init ++ [Enum.at(init, Enum.count(init) - 1) + Enum.at(babies, Enum.count(init) - 1)],
         babies ++ [Enum.at(init, Enum.count(init) - 1)]}
    end
  end

  def call_recurse(rec_list, mult, babies, count) do
    # IO.inspect(rec_list)
    # IO.inspect(babies)

    cond do
      Enum.count(rec_list) >= count ->
        {nlist, babies} = extend_list(rec_list, mult, babies)
        {nlist, babies}

      true ->
        {nlist, babies} = extend_list(rec_list, mult, babies)
        call_recurse(nlist, mult, babies, count)
    end
  end

  def run(input) do
    [n, k] = Enum.map(String.split(input, " ", trim: true), fn x -> String.to_integer(x) end)
    adults = [0, 1]
    babies = [1, 0]
    {r_list, b_list} = call_recurse(adults, k, babies, n-1)

    Enum.at(r_list, Enum.count(r_list) - 1) + Enum.at(b_list, Enum.count(b_list) - 1)
  end
end

{_, file} = File.read("./inputs/5_Mortal_Rabbits.txt")
IO.inspect(Solution.run(file))
