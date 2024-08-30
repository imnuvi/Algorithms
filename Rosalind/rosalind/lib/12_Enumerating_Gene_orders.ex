# https://rosalind.info/problems/perm/

defmodule Permutate do
  def permute([]) do
    []
  end

  def permute([x]) do
    [[x]]
  end

  def permute(ls) do
    Enum.reduce(ls, [], fn x, acc ->
      rem_list = get_remaining_list(ls, x)
      perm = permute(rem_list)

      acc ++
        Enum.map(perm, fn y ->
          [x] ++ y
        end)
    end)
  end

  def get_remaining_list(lss, og_x) do
    index_x = Enum.find_index(lss, fn x -> x == og_x end)

    Enum.slice(lss, 0, index_x) ++ Enum.slice(lss, index_x + 1, Enum.count(lss) - index_x + 1)
  end

  def print_util(lss) do
    IO.puts(Enum.count(lss))

    Enum.each(lss, fn x ->
      IO.puts(Enum.join(x, " "))
    end)
  end

  def run(n) do
    ls = 1..n
    res = permute(ls)
    print_util(res)
  end
end

defmodule EnumerateGeneOrders do
  def run(file) do
    {count, _} = Integer.parse(file)
    Permutate.run(count)
  end
end


{_, file} = File.read("./lib/inputs/12_Enumerating_Gene_orders.txt")
EnumerateGeneOrders.run(file)
