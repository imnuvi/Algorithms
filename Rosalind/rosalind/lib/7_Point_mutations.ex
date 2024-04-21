# https://rosalind.info/problems/hamm/

defmodule PointMutations do
  def collate_differences(index, %{"stranda" => stranda, "strandb" => strandb, "res" => res}) do
    cond do
      String.at(stranda, index) == String.at(strandb, index) ->
        %{"stranda" => stranda, "strandb" => strandb, "res" => res}

      true ->
        %{"stranda" => stranda, "strandb" => strandb, "res" => res + 1}
    end
  end

  def hamming_distance(stranda, strandb) do
    # for x <- 1..String.length(stranda), do
    acc = %{"stranda" => stranda, "strandb" => strandb, "res" => 0}
    Enum.reduce(0..String.length(stranda), acc, &collate_differences/2)
  end

  def run(file_content) do
    [stranda, strandb] = String.split(file_content, "\n", trim: true)
    ham_dict = hamming_distance(stranda, strandb)
    ham_dict["res"]
  end
end

{_, file} = File.read("./lib/inputs/7_point_mutations.txt")
IO.inspect(PointMutations.run(file))
