defmodule PrivatePaper do
  @moduledoc """
  Documentation for PrivatePaper.
  """

IO.puts "Hello world from Elixir"

# First version - lets limit to just one page worth of data.

# Encoding Process:
# Get file list. (If directory, get files in directory.) 
# Zip the files (use erlang zip, zip to memory)
# Encrypt
# Split (later)
# QREncode
# Save the result



# Decoding Process
# Decode the QR images
# Arrange them in order based on part
# |> :zip.extract
# Decrypt the result
# Unzip the resulting binary_part
# Save



  @doc """
  Hello world.

  ## Examples

      iex> PrivatePaper.hello
      :world

  """
  def hello do
    :world
  end
end
