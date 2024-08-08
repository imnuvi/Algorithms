# https://rosalind.info/problems/iprb/
# the idea is to first get the probability of getting a dominant parent from each group
# and then get the probability of selecting a parent from each of the three groups

import Bitwise

defmodule MendelsFirstLaw do
  # def generate_combinations(n, lss, 0) do

  # end
  # def generate_combinations(n, [], depth) do
  #   [n]
  # end

  def flatten_value(tail) when is_list(tail) do
    tail
  end

  def flatten_value(tail) do
    [tail]
  end

  def generate_combinations(val, lss, 1) do
    lss |> Enum.map(fn x -> flatten_value(x) end)
  end

  def generate_combinations(val, lss, depth) when depth-1 == 1 do
    # [n] ++ generate_combinations(lss[0] , Enum.slice(lss, 1..-1))
    # [[n, Enum.at(lss, 0)]] ++ generate_combinations(n, Enum.slice(lss, 1..-1//1))
    # fnum = Enum.at(lss, 0)
    # nlist = Enum.slice(lss, 1..-1//1)
    next_gens = generate_combinations(Enum.at(lss, 0), lss, depth-1)
    IO.inspect(next_gens)
    Enum.map(next_gens, fn x -> [val] ++ flatten_value(x) end)
    |> Enum.map(fn x -> x end)
  end

  def generate_combinations(val, lss, depth) do
    # [n] ++ generate_combinations(lss[0] , Enum.slice(lss, 1..-1))
    # [[n, Enum.at(lss, 0)]] ++ generate_combinations(n, Enum.slice(lss, 1..-1//1))
    # fnum = Enum.at(lss, 0)
    # nlist = Enum.slice(lss, 1..-1//1)
    next_gens = generate_combinations(Enum.at(lss, 0), Enum.slice(lss, 1..-1//1), depth-1)
    IO.inspect(next_gens)
    Enum.map(next_gens, fn x -> [val] ++ flatten_value(x) end)
    |> Enum.map(fn x -> x end)
  end

  def generate_combinations_with_dupe(lss, depth) do
    # [n] ++ generate_combinations(lss[0] , Enum.slice(lss, 1..-1))
    # [[n, Enum.at(lss, 0)]] ++ generate_combinations(n, Enum.slice(lss, 1..-1//1))
    fnum = Enum.at(lss, 0)
    Enum.map(lss, fn x -> [fnum] ++ flatten_value(x) end)
  end


  # bad combinations function. rewriting it

  def gen_combinations([]) do
    []
  end

  def combinations(0, _), do: [[]]
  def combinations(_, []), do: []
  def combinations(size, [head | tail]) do
      (for elem <- combinations(size-1, tail), do: [head|elem]) ++ combinations(size, tail)
  end

  def permutations([]), do: [[]] # <-- (!)
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

  def generate_allele_matrix() do
    # generates the distribution based on the number of genes observed
    %{1 => [1, 1], 2 => [1, 0], 3=> [0,0]}
  end

  def combine_single_gene(gene, org_genes) do
    org_genes |> Enum.map(fn x -> gene ||| x  end)
  end

  def allele_combinations(org_a, org_b) do
    # This function goes through each allele and checks for dominance and recessiveness
    # even if one dominant gene is present, the offspring will be dominant.
    IO.inspect(org_a |> Enum.map(fn x -> combine_single_gene(x, org_b) end))

  end


  def run(file) do
    allele_matrix = generate_allele_matrix()
    counts = file
      |> String.split(" ", trim: true)
      |> Enum.map(
          fn x ->
            {n, _} = Integer.parse(x)
            n
          end
        )
    # allele_matrix
    #   |> Enum.map(
    #       fn x ->
    #         {n, mat} = x
    #         allele_combinations(mat, )
    #       end
    #     )
  end
end

# {_, file} = File.read("./lib/inputs/13_a_Calculating_expected_offspring.txt")
{_, file} = File.read("./inputs/13_a_Calculating_expected_offspring.txt")

IO.inspect(MendelsFirstLaw.run(file))

IO.inspect(MendelsFirstLaw.combinations(2, [1,2,3]))
