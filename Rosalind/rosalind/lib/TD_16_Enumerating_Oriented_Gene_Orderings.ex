# https://rosalind.info/problems/sign/

defmodule EnumeratedOrientedGeneOrderings do
  # def remove_duplicates(ordering_list){
  # }

  # def shuffle(options, count) do
  # end

  # Generates a list of size n with 0's and 1's each from 0 - n in size of array

  # def mix_and_match(n) do
    # this function generates combinations of positive and negative direction combinations
    # Permutations.shuffle([1, -1], n)
    # Permutations.shuffle([1, 2, 3, 4], n)

    # IO.inspect(Permutate.permute([1,2,3,4]))
    # IO.inspect(Permutate.permute())
    # IO.inspect(Permutate.permute([1, -1]))
  # end

  def get_ordering_list() do
    [1, -1]
  end

  def generate_binary_combinations(n, v1 \\ 1, v2 \\ 0) do
    lss = Enum.map(0..n, fn x -> List.duplicate(v1, x) ++ List.duplicate(v2, n-x) end)
    # IO.puts("{{{{{{{{{{{{{{}}}}}}}}}}}}}}")
    # IO.inspect(lss)
    # IO.puts("{{{{{{{{{{{{{{}}}}}}}}}}}}}}")
    # Enum.map(lss, fn x -> Permutate.permute(x) |> Enum.uniq() end)
    Enum.reduce(lss, [], fn x, acc -> acc ++ Permutate.permute(x) |> Enum.uniq() end)
    # Enum.map(0..x, fn x -> 1 end) ++ Enum.map(x..n, fn x -> 0 end)
    # IO.inspect(lss)
  end

  def run(file) do
    {n, _} = Integer.parse(file)

    get_ordering_list()

    # ls = Enum.map(1..n, fn x -> x end) ++ Enum.map(1..n, fn x -> x * -1 end)
    # IO.puts("-----------------")
    # IO.inspect(ls)
    # IO.inspect(mix_and_match(2))
    # IO.puts("%%%%%%%%%%%%%%%%%%%%")
    # IO.inspect(mix_and_match(3))
    # IO.puts("*********************")
    # full_list = Permutate.permute(ls)

    # orderings = Permutate.permute([1,2,3,4])
    orderings = Permutate.permute(1..n)
    # [1,2,3,4])
    signs = generate_binary_combinations(n, -1, 1)


    # Enum.map(orderings, fn x -> Enum.map(signs, fn y -> Utils.Matrices.list_multiplication(x, y) end) end)
    full_processed_list = Enum.reduce(orderings, [], fn x, acc -> acc ++ Enum.map(signs, fn y -> Utils.Matrices.list_multiplication(x, y) end) end)

    Integer.to_string(Enum.count(full_processed_list)) <> "\n" <> Enum.reduce(full_processed_list, "", fn x, acc -> acc <> list_printer(x) end)

  end
  def list_printer(mylist) do
    # Enum.each(x, fn y -> IO.puts(y) end)
    Enum.reduce(mylist, "", fn x, acc ->
      # write_to_file(Integer.to_string(x))
      # write_to_file(" ")
      acc <> Integer.to_string(x) <> " "
    end) <> "\n"
    # Enum.each(mylist, fn x ->
    #   # write_to_file(Integer.to_string(x))
    #   # write_to_file(" ")
    #   IO.write(x)
    #   IO.write(" ")
    # end)

  end

  def write_to_file(text) do
    {:ok, file} = File.open("hello.txt", [:write])
    IO.binwrite(file, text)
  end
end

{_, file} = File.read("./lib/inputs/16_Enumerating_Oriented_Gene_Orderings.txt")
File.write("fixed-haiku.txt", EnumeratedOrientedGeneOrderings.run(file))
