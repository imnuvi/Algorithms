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
      String.length(codon) < 3 ->
        {:err, []}

      protein_code == nil ->
        {:err, []}

      protein_code == "Stop" ->
        cond do
          String.contains?(protein_strand, "M") ->
            # full_protein = protein_strand <> protein_code

            {_, res_strand} =
              chop_strands(String.slice(rna_strand, 3..-1//1), codon_table, "")

            {:ok, [protein_strand] ++ res_strand}

          true ->
            # full_protein = protein_strand <> protein_code

            {_, res_strand} =
              chop_strands(String.slice(rna_strand, 3..-1//1), codon_table, "")

            {:err, res_strand}
        end

      # true ->
      #   cond do
      protein_code == "M" ->
        cond do
          String.contains?(protein_strand, "M") ->
            full_protein = protein_strand <> protein_code

            {_, strand} =
              chop_strands(String.slice(rna_strand, 3..-1//1), codon_table, full_protein)

            {stat, cur_strand} =
              chop_strands(String.slice(rna_strand, 3..-1//1), codon_table, "M")

            {stat, strand ++ cur_strand}

          true ->
            {stat, strand} =
              chop_strands(String.slice(rna_strand, 3..-1//1), codon_table, "M")

            {stat, strand}
        end

      true ->
        full_protein = protein_strand <> protein_code

        {stat, strand} =
          chop_strands(String.slice(rna_strand, 3..-1//1), codon_table, full_protein)

        {stat, strand}
    end

    # end
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
    {_, l3} = Converter.run(strand)
    {_, l2} = Converter.run(String.slice(strand, 1..String.length(strand)))
    {_, l1} = Converter.run(String.slice(strand, 2..String.length(strand)))
    l1 ++ l2 ++ l3
  end

  def read_open_frame({_, strand}) do
    l1 = construct_frames(strand)
    inverse_strand = Inverter.run(strand)
    l2 = construct_frames(inverse_strand)
    l1 ++ l2
  end

  def run(input) do
    lss =
      parse_fasta_file(input)

    Enum.map(lss, fn x -> Enum.join(read_open_frame(x) |> Enum.uniq(), "\n") end)

    # Enum.join(read_open_frame(Enum.at(lss, 0)), "\n")
  end
end

{_, file} = File.read("./inputs/11_Open_Reading_Frames.txt")

IO.inspect(Solution.run(file))

Enum.each(Solution.run(file), fn x ->
  IO.puts(x)
  IO.puts("-------------")
end)
