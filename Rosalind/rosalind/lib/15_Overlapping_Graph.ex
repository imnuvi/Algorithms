# https://rosalind.info/problems/grph/

defmodule OverlappingGraph do
  def parse_identifier_strand(single_line) do
    # TO-DO: move this to a different module that handles utilities
    split = String.split(single_line, "\n")
    {Enum.at(split, 0), Enum.join(Enum.slice(split, 1..Enum.count(split)))}
  end

  def parse_fasta_file(file_content) do
    # TO-DO: move this to a different module that handles utilities
    file_content
    |> String.split(">", trim: true)
    |> Enum.map(&parse_identifier_strand/1)
  end

  def split_string_ends(x) do
    crop_length = get_crop_length()
    { elem(x,0), String.slice(elem(x,1), 0..crop_length-1), String.slice(elem(x,1), String.length(elem(x,1))-3..String.length(elem(x,1))) }
  end

  def get_crop_length() do
    3
  end

  def filter_search_element(elem, search) do
    {_, head, _} = elem
    search == head
  end

  def main_filter_runner(processed_list, x) do
      {name, _ ,tail} = Enum.at(processed_list, x)
      List.delete_at(processed_list, x)
      |> Enum.filter(fn x ->  filter_search_element(x, tail) end)
      |> Enum.map(fn {mat_name, _, _} -> {name, mat_name} end)
  end

  def iterate_processed_list(processed_list) do
    count = Enum.count(processed_list)
    0..count-1 |> Enum.map(fn x -> main_filter_runner(processed_list, x) end) |> Enum.reduce([], fn x, acc -> acc ++ x end)
  end


  def run(file) do
    lss =
      parse_fasta_file(file)

    full_processed_list = lss
    |> Enum.map(&split_string_ends/1)

    iterate_processed_list(full_processed_list)
    |> Enum.each(
      fn {x, y} ->
        IO.puts(x <> " " <> y)
      end
    )
  end
end

{_, file} = File.read("./lib/inputs/15_Overlapping_Graph.txt")

OverlappingGraph.run(file)
