defmodule RosalindTest do
  use ExUnit.Case
  doctest Rosalind

  test "greets the world" do
    assert Rosalind.hello() == :world
  end
end
