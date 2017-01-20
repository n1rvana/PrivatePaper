defmodule PrivatePaper.CLI do
 
  @moduledoc """
  Command Line Interface support for private paper.  
  """

    @doc """
    Main - Parses command line arguments, and starts processing based on them.

    ## Examples

        iex> PrivatePaper.main 
        :ok

    """
    def main(_args) do
      # Parse options later, right now lets just test with hard coded data.
      # {options, _, _} = OptionParser.parse(argv, 
      # switches: [question: :string],)
      password = "ElixirIsGreat"
      IO.puts "Making temporary directory for intermediate files at #{PrivatePaper.temp_directory}."
      IO.puts Porcelain.shell("mkdir #{PrivatePaper.temp_directory()}; rm -r #{PrivatePaper.temp_directory()}/*; mkdir #{PrivatePaper.temp_directory()}/unzipped").out
      IO.puts Porcelain.shell("echo \"Private paper could be great.\" > #{PrivatePaper.temp_directory()}/source.txt").out

      # Problem: Our QR tools only support tiny amounts of data. So we're just using a single string
      # For now we just do a round trip on the test data
      PrivatePaper.zip_files("#{PrivatePaper.temp_directory()}/source.txt")
      |> PrivatePaper.print_hash  # This prints out hash of the source
      |> PrivatePaper.encrypt(password)
      |> PrivatePaper.qr_encode("#{PrivatePaper.temp_directory()}/qrimage.png") # path is destination for images
      
      PrivatePaper.qr_decode("#{PrivatePaper.temp_directory()}/qrimage.png") # path is source for images
      |> PrivatePaper.decrypt(password)
      |> PrivatePaper.print_hash  # This prints out hash of the decoded zip
      |> PrivatePaper.unzip_files("#{PrivatePaper.temp_directory()}/unzipped")

      # Check the hashes to see if they are identical.
      IO.puts("Check to make sure hashes match!")
    :ok
    end
  
 end