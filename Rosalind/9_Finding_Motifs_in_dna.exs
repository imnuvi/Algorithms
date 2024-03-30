# https://rosalind.info/problems/hamm/

defmodule Solution do
  def count_indexes(x, acc) do
    [ls, _] = x
    acc ++ [elem(ls, 0) + 1]
  end

  def run(file_content) do
    [full_strand, search_strand] = String.split(file_content, "\n", trim: true)

    {_, compiled_regex} = Regex.compile("(?=(" <> search_strand <> "))")

    Regex.scan(compiled_regex, full_strand, return: :index)
    |> Enum.reduce([], &count_indexes/2)
    # |> Enum.each(fn x -> IO.puts(x) end)
    |> Enum.join(" ")
  end
end

{_, file} = File.read("./inputs/9_Finding_Motifs_in_dna.txt")
IO.puts(Solution.run(file))
# Solution.run(file)
