# https://rosalind.info/problems/gc/

defmodule GCCount do
  def dna_splitter(input_line) do
    split = String.split(input_line, "\n")
    {Enum.at(split, 0), Enum.join(Enum.slice(split, 1..Enum.count(split)))}
  end

  def gc_counter({title, dna_seq}) do
    frequencies = dna_seq |> String.graphemes() |> Enum.frequencies()

    %{
      "title" => title,
      "count" => (Map.get(frequencies, "G") + Map.get(frequencies, "C")) / String.length(dna_seq)
    }
  end

  def get_max_count(x, acc) do
    cond do
      x["count"] > acc["count"] ->
        x

      true ->
        acc
    end
  end

  def run(input) do
    lss =
      String.split(input, ">", trim: true)
      |> Enum.map(&dna_splitter/1)
      |> Enum.map(&gc_counter/1)
      |> Enum.reduce(&get_max_count/2)

    IO.puts(lss["title"])
    IO.inspect(lss["count"] * 100)
  end
end

{_, file} = File.read("./lib/inputs/6_GC_count.txt")
GCCount.run(file)
