# https://rosalind.info/problems/sign/

defmodule EnumeratedOrientedGeneOrderings do
  def get_ordering_list() do
    [1, -1]
  end

  def generate_binary_combinations(n, v1 \\ 1, v2 \\ 0) do
    lss = Enum.map(0..n, fn x -> List.duplicate(v1, x) ++ List.duplicate(v2, n-x) end)
    Enum.reduce(lss, [], fn x, acc -> acc ++ Permutate.permute(x) |> Enum.uniq() end)
  end

  def run(file) do
    {n, _} = Integer.parse(file)

    get_ordering_list()
    orderings = Permutate.permute(1..n)
    signs = generate_binary_combinations(n, -1, 1)


    # Enum.map(orderings, fn x -> Enum.map(signs, fn y -> Utils.Matrices.list_multiplication(x, y) end) end)
    full_processed_list = Enum.reduce(orderings, [], fn x, acc -> acc ++ Enum.map(signs, fn y -> Utils.Matrices.list_multiplication(x, y) end) end)

    Integer.to_string(Enum.count(full_processed_list)) <> "\n" <> Enum.reduce(full_processed_list, "", fn x, acc -> acc <> list_printer(x) end)

  end
  def list_printer(mylist) do
    Enum.reduce(mylist, "", fn x, acc ->
      acc <> Integer.to_string(x) <> " "
    end) <> "\n"
  end

  def write_to_file(text) do
    {:ok, file} = File.open("hello.txt", [:write])
    IO.binwrite(file, text)
  end
end

{_, file} = File.read("./lib/inputs/16_Enumerating_Oriented_Gene_Orderings.txt")
File.write("fixed-haiku.txt", EnumeratedOrientedGeneOrderings.run(file))
