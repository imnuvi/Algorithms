# https://rosalind.info/problems/mrna/

defmodule MRNAFromProtein do
  def add_codon_count(x, acc) do
    protein = Enum.at(x, -1)
    # codon = Enum.at(x, 0)

    cond do
      Map.has_key?(acc, protein) ->
        Map.put(acc, protein, Map.get(acc, protein) + 1)

      true ->
        Map.put(acc, protein, 1)
    end
  end

  def get_codon_counts() do
    {_, table} = File.read("./lib/constants/RNA_codon_table.txt")

    table
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " ", trim: true) end)
    |> Enum.reduce(%{}, &add_codon_count/2)
  end

  # def run_codon_mod(protein, codon_table, fin, mod_val) do
  def run_codon_mod(protein_string, codon_table, mod_val) do
    Enum.reduce(protein_string, Map.get(codon_table, "Stop"), fn protein, acc ->
      rem(acc * Map.get(codon_table, protein), mod_val)
    end)
  end

  def run(file_content) do
    [rna_strand] = String.split(file_content, "\n", trim: true)

    codon_table = get_codon_counts()
    mod_val = 1_000_000

    rna_strand
    |> String.split("", trim: true)
    |> run_codon_mod(codon_table, mod_val)
  end
end

# {_, file} = File.read("./inputs/10_Inferring_mrna_from_Protein.txt")
{_, file} = File.read("./lib/inputs/10_Inferring_mrna_from_Protien.txt")
IO.inspect(MRNAFromProtein.run(file))
