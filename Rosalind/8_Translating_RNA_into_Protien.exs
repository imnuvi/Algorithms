# https://rosalind.info/problems/hamm/

defmodule Solution do

  def get_codon_table() do
    {_, table} = File.read("./constants/RNA_codon_table.txt")
    table
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " ", trim: true)  end)
    |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, Enum.at(x, 0), Enum.at(x, -1)) end)
  end

  def chop_strands("", _) do
    ""
  end

  def chop_strands(rna_strand, codon_table) do
    codon = String.slice(rna_strand, 0..2)
    protein_code = Map.get(codon_table, codon)
    cond do
      protein_code == "Stop" ->
        chop_strands("", codon_table)
      true ->
        protein_code <> chop_strands(String.slice(rna_strand, 3..-1//1), codon_table)
    end
  end

  def run(rna_strand) do
    codon_table = get_codon_table()
    chop_strands(rna_strand, codon_table)
  end

end


{_, file} = File.read("./inputs/8_Translating_RNA_into_Protien.txt")
IO.puts(Solution.run(file))
