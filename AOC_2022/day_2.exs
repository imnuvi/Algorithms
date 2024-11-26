# https://adventofcode.com/2022/day/2


defmodule Solution do
  def get_maps() do
    opponent_map = %{"A" => "rock", "B" => "paper", "C" => "scissor"}
    expected_map = %{"X" => "rock", "Y" => "paper", "Z" => "scissor"}
    score_map = %{"rock" => 1, "paper" => 2, "scissor" => 3}
    winning_map = %{"rock" => "scissor", "scissor" => "paper", "paper" => "rock"}
    losing_map = %{"rock" => "paper", "scissor" => "rock", "paper" => "scissor"}

    {opponent_map, expected_map, score_map, winning_map, losing_map}
  end

  def calculate_single_run_score([opponent, you], {opponent_map, expected_map, score_map, winning_map, _losing_map}) do
    opp_move = Map.get(opponent_map, opponent)
    exp_move = Map.get(expected_map, you)
    exp_earning = Map.get(score_map, exp_move)
    win_check = Map.get(winning_map, exp_move)
    cond do
      opp_move == win_check ->
        6 + exp_earning
      opp_move == exp_move ->
        3 + exp_earning
      true ->
        exp_earning
    end
  end

  def calculate_prediction_run_score([opponent, you], {opponent_map, _expected_map, score_map, winning_map, losing_map}) do
    opp_move = Map.get(opponent_map, opponent)

    win_check = Map.get(winning_map, opp_move)
    lose_check = Map.get(losing_map, opp_move)
    case you do
      "X" ->
        Map.get(score_map, win_check) + 0
      "Y" ->
        Map.get(score_map, opp_move) + 3
      "Z" ->
        Map.get(score_map, lose_check) + 6
    end
  end

  def run(file, part) do
    {_, res} = File.read(file)
    maps = get_maps()
    processed_list = res
      |> String.split("\n")
      |> Enum.map(fn x -> String.split(x, " ", trim: true) end)

    case part do
      :one ->
        processed_list
          |> Enum.map(fn x -> calculate_single_run_score(x, maps) end)
          |> Enum.sum()

      :two ->
        processed_list
          |> Enum.map(fn x -> calculate_prediction_run_score(x, maps) end)
          |> Enum.sum()
    end
  end
end

IO.inspect(Solution.run("./inputs/day_2.txt", :one))
IO.inspect(Solution.run("./inputs/day_2.txt", :two))
