defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  @doc """
    Given a string deterministic create an identicon
    pipes output through helpers until image is created
  ## Examples

      iex> Identicon.main
      :world

  """
  def main(input) do
    input
    |> hash_input
  end

  @doc """
  Generate a list of numbers from a string
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
