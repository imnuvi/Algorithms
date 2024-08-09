# https://rosalind.info/problems/iprb/
# the idea is to first get the probability of getting a dominant parent from each group
# and then get the probability of selecting a parent from each of the three groups

import Bitwise

defmodule MendelsFirstLaw do
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
    case index do
      0 ->
        {[Enum.at(list, index)], [Enum.at(list,index) - 1] ++ Enum.slice(list, index+1..-1//1)}
      _ ->
        {[Enum.at(list, index)], Enum.slice(list, 0..index-1) ++ [Enum.at(list,index) - 1] ++ Enum.slice(list, index+1..-1//1)}
    end
  end

  def merge_taken_elements(x, acc) do
      {takes, ncc} = elem_taker(Enum.at(elem(acc,1), -1), x-1)
      {elem(acc, 0) ++ takes, elem(acc,1) ++ [ncc]}
  end


  def mendel_helper(match, counts) do
    # here counts is the options for parent
    allele_matrix = generate_allele_matrix()
    # simulating selection without replacing
    count_makes = match |> Enum.reduce({[], [counts]}, &merge_taken_elements/2)
    # getting the allele table for each organism
    match_alleles = match |> Enum.map(fn x -> Map.get(allele_matrix, x) end)
    # calculating the partial probabilites by getting the options with total options and multiplying them.
    partial_probabilities = 0..Enum.count(match)-1
    |> Enum.map(fn
      x->
        Enum.at(elem(count_makes,0), x)/Enum.reduce(

          Enum.at(elem(count_makes, 1), x), fn
            x, acc -> x + acc
          end
        )
      end
    )
    |> Enum.reduce(1, fn x, acc -> x * acc end)

    # this calculates the expected dominance of the distribution
    dominance_dist = allele_combinations(Enum.at(match_alleles, 0), Enum.at(match_alleles, 1))
    partial_probabilities * dominance_dist
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
  end
end

{_, file} = File.read("./inputs/13_a_Calculating_expected_offspring.txt")

IO.inspect(MendelsFirstLaw.run(file))
