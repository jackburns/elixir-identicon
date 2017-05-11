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
    |> pick_color
    |> build_grid
  end

  @doc """
  Generate a list of numbers from a string
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list
    %Identicon.Image{hex: hex}
  end

  @doc """
  Extract image color from first three hex values
  """
  def pick_color(image) do
    [r, g, b | _tail] = image.hex
    %Identicon.Image{image | color: {r, g, b}}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end
  
  @doc """
  Build a grid from a hex list
  chunks into lists of 3 and then mirrors the first two elements
  """
  def build_grid(image) do
    image.hex
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row/1)
  end

end
