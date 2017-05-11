defmodule Identicon.Image do
  @moduledoc """
  Image struct that holds data to generate Identicon
  """
  defstruct [
    hex: nil,
    color: nil,
    grid: nil
  ]
end
