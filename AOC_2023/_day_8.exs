defmodule Solution do
  def construct_map(line, resmap) do
    [mkey, mval] = String.split(line, " = ", trim: true)
    [lkey, rkey] = String.split(mval, ", ", trim: true)
    lkey = String.trim(String.trim(lkey, "("), ")")
    rkey = String.trim(String.trim(rkey, "("), ")")

    # IO.inspect(mkey)
    # IO.inspect(mval)
    # IO.inspect(lkey)
    # IO.inspect(rkey)

    cond do
      Map.has_key?(resmap, mkey) ->
        nil

      true ->
        Map.put(resmap, mkey, [lkey, rkey])
    end
  end

  def calculate_movement(_movestream, "ZZZ", _maps, count) do
    count
  end

  def calculate_movement(movestream, mkey, maps, count) do
    [l_elem, r_elem] = Map.get(maps, mkey)

    {[curmove], moveset} = {Enum.take(movestream, 1), Stream.drop(movestream, 1)}
    IO.inspect(curmove)
    IO.inspect(l_elem)
    IO.inspect(r_elem)

    case curmove do
      "L" ->
        calculate_movement(moveset, l_elem, maps, count + 1)

      "R" ->
        calculate_movement(moveset, r_elem, maps, count + 1)
    end
  end

  # def calculate_movement(commannd_list, key, movemap) do
  #   [L, R] = Map.get(movemap, key)
  #   commannd_list |>

  #   cond do k
  # end

  def run(_part) do
    {_, res} = File.read('./inputs/day_8.txt')

    input =
      res
      |> String.split("\n", trim: true)
      |> Enum.to_list()

    # |> Enum.each(fn x -> IO.puts(x) end)

    maps =
      Enum.slice(input, 1..-1)
      |> Enum.reduce(%{}, fn x, acc -> construct_map(x, acc) end)

    IO.inspect(maps)

    Enum.at(input, 0)
    |> String.split("", trim: true)
    |> Stream.cycle()
    |> calculate_movement("AAA", maps, 0)

    # construct_map(Enum.at(maps, 0), %{})
  end
end

IO.inspect(Solution.run(:one))
