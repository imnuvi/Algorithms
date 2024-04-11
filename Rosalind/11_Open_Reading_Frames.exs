# https://rosalind.info/problems/mrna/

defmodule Inverter do
  def get_base_pairs() do
    %{"A" => "T", "T" => "A", "G" => "C", "C" => "G"}
  end

  def run(dna_strand) do
    base_pairs = get_base_pairs()

    String.split(dna_strand, "", trim: true)
    |> Enum.map(fn x ->
      Map.get(base_pairs, x)
    end)
    |> Enum.reverse()
    |> List.to_string()
  end

  def strip_to_triplets(strand) do
    IO.puts(strand)
  end
end

# https://rosalind.info/problems/prot/

defmodule Converter do
  def get_codon_table() do
    {_, table} = File.read("./constants/DNA_codon_table.txt")

    table
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " ", trim: true) end)
    |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, Enum.at(x, 0), Enum.at(x, -1)) end)
  end

  def chop_strands(rna_strand, codon_table, protein_strand) do
    codon = String.slice(rna_strand, 0..2)
    protein_code = Map.get(codon_table, codon)

    cond do
      protein_code == nil ->
        {:err, ""}

      protein_code == "Stop" ->
        cond do
          String.contains?(protein_strand, "M") ->
            {:ok, protein_strand}

          true ->
            {:err, ""}
        end

      String.length(codon) < 3 ->
        {:err, ""}

      true ->
        cond do
          protein_code == "M" ->
            cond do
              String.contains?(protein_strand, "M") ->
                full_protein = protein_strand <> protein_code

                {stat, strand} =
                  chop_strands(String.slice(rna_strand, 3..-1//1), codon_table, full_protein)

              true ->
                {stat, strand} =
                  chop_strands(String.slice(rna_strand, 3..-1//1), codon_table, "M")
            end

          true ->
            full_protein = protein_strand <> protein_code

            {stat, strand} =
              chop_strands(String.slice(rna_strand, 3..-1//1), codon_table, full_protein)
        end
    end
  end

  def get_regex_pos(strand, pattern) do
    {_, compiled_regex} = Regex.compile(pattern)
    Regex.scan(compiled_regex, strand, return: :index)
  end

  def get_valid_strand(rna_strand) do
    codon_table = get_codon_table()
    # ss = String.split(rna_strand, "ATG")
    _ = get_regex_pos(rna_strand, "ATG")
    chop_strands(rna_strand, codon_table, "")
  end

  def run(rna_strand) do
    get_valid_strand(rna_strand)
  end
end

defmodule Solution do
  def parse_identifier_strand(single_line) do
    split = String.split(single_line, "\n")
    {Enum.at(split, 0), Enum.join(Enum.slice(split, 1..Enum.count(split)))}
  end

  def parse_fasta_file(file_content) do
    file_content
    |> String.split(">", trim: true)
    |> Enum.map(&parse_identifier_strand/1)
  end

  def get_codon_table() do
    {_, table} = File.read("./constants/DNA_codon_table.txt")

    table
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " ", trim: true) end)
    |> Enum.reduce(%{}, fn x, acc ->
      Map.put(acc, String.replace(Enum.at(x, 0), "U", "T"), Enum.at(x, -1))
    end)
  end

  def construct_frames(strand) do
    IO.inspect(Converter.run(strand))
    IO.inspect(Converter.run(String.slice(strand, 1..String.length(strand))))
    IO.inspect(Converter.run(String.slice(strand, 2..String.length(strand))))
  end

  def read_open_frame({_, strand}) do
    construct_frames(strand)
    inverse_strand = Inverter.run(strand)
    construct_frames(inverse_strand)
  end

  def run(input) do
    lss = parse_fasta_file(input)
    read_open_frame(Enum.at(lss, 0))
  end
end

{_, file} = File.read("./inputs/11_Open_Reading_Frames.txt")
Solution.run(file)
