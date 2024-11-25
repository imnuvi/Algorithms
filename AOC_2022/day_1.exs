defmodule Solution do
  def run(file, part) do
    {_, res} = File.read(file)

    processed_calories =
      res
      |> String.split("\n")
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(fn group -> group == [""] end)
      |> Enum.map(fn x -> Enum.sum(Enum.map(x,
        fn
          x ->
            {n, _} = Integer.parse(x)
            n
        end
        ))
      end)

    case part do
      :one ->
        Enum.max(processed_calories)

      :two ->
        processed_calories
          |> Enum.sort(:desc)
          |> Enum.take(3)
          |> Enum.sum()
    end
  end
end


IO.inspect(Solution.run("./inputs/day_1.txt", :two))
