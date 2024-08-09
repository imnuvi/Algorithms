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

  def permute_two(elements) do
    for x <- elements, y <- elements, x != y, do: [x, y]
  end

  def permute_two_with_dupes(elements) do
    for x <- elements, y <- elements,  do: [x, y]
  end

  def generate_allele_matrix() do
    # generates the distribution based on the number of genes observed
    %{1 => [1, 1], 2 => [1, 0], 3=> [0,0]}
  end

  def generate_dominance() do
    # generates a map that has the dominance probability distribution

  end

  def combine_single_gene(gene, org_genes) do
    org_genes |> Enum.map(fn x -> gene ||| x  end)
  end

  def allele_combinations(org_a, org_b) do
    # This function goes through each allele and checks for dominance and recessiveness based on homozygous dominant, homozygous recessive and heterozygous
    # RR, Rr, rR, rr
    # here 1 is dominant, 0 is recessive
    # even if one dominant gene is present, the offspring will be dominant.
    offspring_dominance = org_a |> Enum.reduce([], fn x, acc -> acc ++ combine_single_gene(x, org_b) end)
    # this calculates the probability
    dominant_offspring = offspring_dominance |> Enum.filter(fn x -> x == 1 end)
    Enum.count(dominant_offspring) / Enum.count(offspring_dominance)
  end

  def elem_taker(list, index) do
    # takes a single element from a list and reduces its value by one.
    # zero indexed
    # {Enum.at(list, index), Enum.slice(list, 0..index), Enum.slice(list, index..-1//1)}
    # IO.puts("-------------")
    # IO.inspect(list)
    # IO.inspect(index)
    # IO.inspect(Enum.at(list, index))
    # IO.inspect([Enum.at(list,index) - 1])
    # IO.inspect(Enum.slice(list, 0..index))
    # IO.inspect(Enum.slice(list, index+1..-1//1))

    # {[Enum.at(list, index)], Enum.slice(list, 0..index-1) ++ [Enum.at(list,index) - 1] ++ Enum.slice(list, index+1..-1//1)}

    case index do
      0 ->
        {[Enum.at(list, index)], [Enum.at(list,index) - 1] ++ Enum.slice(list, index+1..-1//1)}
      _ ->
        {[Enum.at(list, index)], Enum.slice(list, 0..index-1) ++ [Enum.at(list,index) - 1] ++ Enum.slice(list, index+1..-1//1)}
    end
  end

  def merge_taken_elements(x, acc) do
      # IO.inspect(x)
      # IO.inspect(x-1)
      # IO.inspect(elem(acc,1))
      # IO.inspect(Enum.at(elem(acc,1), -1))
      {takes, ncc} = elem_taker(Enum.at(elem(acc,1), -1), x-1)
      # IO.inspect({elem(acc, 0) ++ takes, elem(acc,1) ++ [ncc]})
      {elem(acc, 0) ++ takes, elem(acc,1) ++ [ncc]}
  end


  def mendel_helper(match, counts) do
    # here counts is the options for parent
    allele_matrix = generate_allele_matrix()
    total_count = Enum.reduce(counts, 0, fn x, acc -> x + acc end)
    ncounts = counts
    # 0..Enum.count(ncounts) |> Enum.reduce({ncounts}fn x -> element_taker(x, ncounts) end
    IO.puts("----------")
    # IO.inspect(ncounts)
    # IO.inspect(match)
    # IO.inspect(allele_matrix)
    # IO.inspect(total_count)

    count_makes = match |> Enum.reduce({[], [counts]}, &merge_taken_elements/2)
    match_alleles = match |> Enum.map(fn x -> Map.get(allele_matrix, x) end)
    IO.inspect(count_makes)
    IO.inspect(match_alleles)
    partial_probabilities = 0..Enum.count(match)-1
    # |> Enum.map(fn x -> x end)
    |> Enum.map(fn
      x->
        # IO.inspect(Enum.at(elem(count_makes,0), x))
        Enum.at(elem(count_makes,0), x)/Enum.reduce(

          Enum.at(elem(count_makes, 1), x), fn
            x, acc -> x + acc
          end
        )
      end
    )
    |> Enum.reduce(1, fn x, acc -> x * acc end)

    dominance_dist = allele_combinations(Enum.at(match_alleles, 0), Enum.at(match_alleles, 1))

    IO.inspect(dominance_dist)
    IO.inspect(partial_probabilities)
    partial_probabilities * dominance_dist
    # Map.get(match)
    # IO.puts("----------")


  end


  def run(file) do
    precision = 5
    allele_matrix = generate_allele_matrix()
    counts = file
      |> String.split(" ", trim: true)
      |> Enum.map(
          fn x ->
            {n, _} = Integer.parse(x)
            n
          end
        )
    Map.keys(allele_matrix) |>
      permute_two_with_dupes() |>
      Enum.map(fn x -> mendel_helper(x, counts) end) |>
      Enum.reduce(0, fn x, acc -> acc + x end) |>
      Float.round(precision)
      # Enum.each(fn x -> IO.inspect(x) end)
    # allele_matrix
    #   |> Enum.map(
    #       fn x ->
    #         {n, mat} = x
    #       end
    #     )
  end
end

# {_, file} = File.read("./lib/inputs/13_a_Calculating_expected_offspring.txt")
{_, file} = File.read("./inputs/13_a_Calculating_expected_offspring.txt")

IO.inspect(MendelsFirstLaw.run(file))
# IO.inspect(MendelsFirstLaw.elem_taker([0,1,2,3,4,5], 5))
