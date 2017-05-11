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
    |> draw_image
    |> save_image(input)
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
    grid = image.hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.filter(fn(x) -> rem(x, 2) == 0 end)
      |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  @doc """
  contruct image using erlangs egd lib using image grid and color
  """
  def draw_image(image) do
    pixelmap = :egd.create(250, 250)
    color = :egd.color(image.color)
    for {_code, index} <- image.grid do
      x_coord = rem(index, 5) * 50
      y_coord = div(index, 5) * 50
      p1 = {x_coord, y_coord}
      p2 = {x_coord + 50, y_coord + 50}
      :egd.filledRectangle(pixelmap, p1, p2, color)
    end
    :egd.render(pixelmap)
  end

  @doc """
  saves image to filesystem as a png
  """
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end
end
