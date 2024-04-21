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
end

{_, file} = File.read("./lib/inputs/3_ComplementaryStrand.txt")
IO.inspect(Inverter.run(file))
