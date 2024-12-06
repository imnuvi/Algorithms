defmodule Solution do
  def get_window(matrix, row_start, row_end, col_start, col_end) do
    matrix
    |> Enum.slice(row_start..row_end)
    |> Enum.map(fn row -> Enum.slice(row, col_start..col_end) end)
  end

  def search_window_index_list(text_list, window_index_list) do
    Enum.reduce(window_index_list, "",fn
      {x,y}, acc ->
        x_list = Enum.at(text_list, x)
        cond do
          x_list != nil ->
            elem_coincidence = Enum.at(x_list, y)
            cond do
              elem_coincidence != nil ->
                acc <> elem_coincidence
              true ->
                acc
            end
          true ->
            acc
        end
    end)
  end

  def calculate_x_mas_indices(posx, posy) do
    template_x_mas = [{0,0},{1,1},{-1,-1},{1,-1},{-1,1}]
    Enum.map(template_x_mas, fn {x, y} ->
      nposx = posx - x
      nposy = posy - y
      cond do
        nposx < 0 or nposy < 0 ->
          nil
        true ->
          {nposx, nposy}
      end
    end
    )
    # |> Enum.filter(fn x -> x != nil end)
  end

  def calculate_window_indices(posx, posy) do
    # IO.inspect(posx)
    # IO.inspect(posy)
    # IO.inspect('----------------')
    template_topright = [{0,0},{1,1},{2,2},{3,3}]
    template_topleft = [{0,0},{-1,1},{-2,2},{-3,3}]
    template_bottomright = [{0,0},{1,-1},{2,-2},{3,-3}]
    template_bottomleft = [{0,0},{-1,-1},{-2,-2},{-3,-3}]

    template_forward = [{0,0},{1,0},{2,0},{3,0}]
    template_reverse = [{0,0},{-1,0},{-2,0},{-3,0}]
    template_up = [{0,0},{0,1},{0,2},{0,3}]
    template_down = [{0,0},{0,-1},{0,-2},{0,-3}]

    full_templates = [template_topright, template_topleft, template_bottomright, template_bottomleft, template_forward, template_reverse, template_up, template_down]

    Enum.map(full_templates, fn
      llist -> Enum.map(llist, fn {x, y} ->
        nposx = posx - x
        nposy = posy - y
        cond do
          nposx < 0 or nposy < 0 ->
            nil
          true ->
            {nposx, nposy}
        end
      end
      ) |> Enum.filter(fn x -> x != nil end)
    end)

    # topright_indices = Enum.each(template_topright, fn {x,y} -> {posx + x, posy + y} end)
    # topleft_indices = Enum.each(template_topleft, fn {x,y} -> {posx + x, posy + y} end)
    # bottomright_indices = Enum.each(template_topright, fn {x,y} -> {posx + x, posy + y} end)
    # bottomleft_indices =Enum.each(template_topright, fn {x,y} -> {posx + x, posy + y} end)
    # forward_indices =Enum.each(template_topright, fn {x,y} -> {posx + x, posy + y} end)
    # backward_indices =Enum.each(template_topright, fn {x,y} -> {posx + x, posy + y} end)
    # upward_indices =Enum.each(template_topright, fn {x,y} -> {posx + x, posy + y} end)
    # downward_indices =Enum.each(template_topright, fn {x,y} -> {posx + x, posy + y} end)
  end

  def calculate_window(posx, posy) do
    # calculates the window length given the mid point for the window
    # here the window is mid +- 3 in x and mid +- 3 in y adjusted for negative indices
    word = "XMAS"
    wordlen = String.length(word)
    xstart = posx - wordlen
    xend = posx + wordlen - 1
    ystart = posy - wordlen
    yend = posy + wordlen - 1
    {xstart, xend, ystart, yend}
  end

  def process_2d_list(res) do
    # IO.inspect(search_window_index_list(res,[{1, 0}, {2, 1}, {3, 2}, {4, 3}]))
    # IO.inspect(search_window_index_list(res, [{1, 18}, {2, 19}, {3, 20}, {4, 21}]))
    index_list = res
      |> Enum.map(fn x -> Enum.map(Enum.filter(Enum.with_index(x), fn {x, _} -> x=="X" end), fn {_, pos} -> pos end) end)
      |> Stream.with_index()
      |> Enum.map(fn {x, index} -> Enum.map(x, fn y -> calculate_window_indices(index, y) end) end)
      |> Enum.reduce([], fn x, acc -> acc ++ x end )
      |> Enum.reduce([], fn x, acc -> acc ++ x end )
      |> Enum.map(fn x -> search_window_index_list(res, x) end)
      |> Enum.filter(fn x -> x == "XMAS" end)
      |> Enum.count()

      # |> Enum.map(fn x -> Enum.map(x, fn y -> Enum.map(y, fn z -> z end)) end)
      # |> Enum.map(fn x -> Enum.map(x, fn y -> calculate_window_indices(x,y) end) end)
  end

  def process_2d_xmas_list(res) do
    # IO.inspect(search_window_index_list(res,[{1, 0}, {2, 1}, {3, 2}, {4, 3}]))
    # IO.inspect(search_window_index_list(res, [{1, 18}, {2, 19}, {3, 20}, {4, 21}]))
    index_list = res
      |> Enum.map(fn x -> Enum.map(Enum.filter(Enum.with_index(x), fn {x, _} -> x=="A" end), fn {_, pos} -> pos end) end)
      |> Stream.with_index()
      |> Enum.map(fn {x, index} -> Enum.map(x, fn y -> calculate_x_mas_indices(index, y) end) end)
      |> Enum.reduce([], fn x, acc -> acc ++ x end )
      |> Enum.filter(fn x -> Enum.all?(x, fn y -> y != nil end) end)
      |> Enum.map(fn x -> search_window_index_list(res, x) end)
      |> Enum.filter(fn x ->
        cond do
          ((String.at(x, 1) == String.at(x, 2)) or (String.at(x, 3) == String.at(x, 4))) ->
            false
          (Enum.sort(String.split(x, "", trim: true )) == ["A", "M", "M", "S", "S"]) ->
            true
          true ->
            false
        end
      end)
      |> Enum.count()

      # |> Enum.map(fn x -> Enum.map(x, fn y -> Enum.map(y, fn z -> z end)) end)
      # |> Enum.map(fn x -> Enum.map(x, fn y -> calculate_window_indices(x,y) end) end)
  end

  def run(file, part) do
        {_, res} = File.read(file)

        processed = res
          |> String.split("\n", trim: true)
          |> Enum.map(fn x -> String.split(x, "", trim: true) end)

        ydim = Enum.count(processed)
        xdim = Enum.count(Enum.at(processed, 0))

        case part do
          :one ->
            processed
              |> process_2d_list()
              # |> get_window(3, 200, 3, 600)
          :two ->
            processed
              |> process_2d_xmas_list()
          end
      end
end

IO.inspect(Solution.run("./inputs/day_4.txt", :one))
# Solution.run("./inputs/day_41.txt", :one)
IO.inspect(Solution.run("./inputs/day_4.txt", :two))
