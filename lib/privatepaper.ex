defmodule PrivatePaper do
  @moduledoc """
    Digital information zipped up, encrypted, run-length encoded for fidelity, and printed out as a QR code. All the fidelity and security of encrypted digital files with the extremely low information density of paper!
    Put it in a safe!  
    This module contains the key functionality for Private Paper
    """


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

  ##########################################################################
  ## COMPRESSION
  ##########################################################################

  @doc """
    Zip up files combining them into one file and compressing them.
    ## Examples

      iex> PrivatePaper.zip_files "./test_data/source" 
      :ok

  """
  def zip_files(source) do
    source |> File.read! |> :zlib.compress
  end

  @doc """
    Unzip files inflating them and putting the result in the given directory.
    Takes a binary that is the zip archive.
    ## Examples

      iex> PrivatePaper.zip_files "test_data/compressed.zip" "./test_data/unzipped" 
      :ok

  """
  def unzip_files(archive, destination) do
    File.write!(archive |> :zlib.uncompress, destination)
  end

  ##########################################################################
  ## Cryptography
  ##########################################################################
   
  @doc """
    Encrypt the data using key plus a KDF to improve the password.

    ## Examples

      iex> PrivatePaper.zip_files "./test_data/source" 
      :ok

  """
  def encrypt(raw, password) do
    iv = :crypto.strong_rand_bytes(16)
    key = key_from_password(password)
    state = :crypto.stream_init(:aes_ctr, key, iv)
    {_new_state, ciphertext} = :crypto.stream_encrypt(state, raw)
    IO.puts("The ciphertext's hash is: #{:crypto.hash(:sha256, ciphertext) |> Base.encode16(case: :lower)}")
    iv <> ciphertext
  end

  @doc """
    Decrypt the data.
    ## Examples

      iex> PrivatePaper.decrypt 
      :ok

  """
  def decrypt(encrypted, password) do
    <<iv::binary-16, ciphertext::binary>> = encrypted
    IO.puts("The ciphertext's hash is: #{:crypto.hash(:sha256, ciphertext) |> Base.encode16(case: :lower)}")
    key = key_from_password(password)
    state = :crypto.stream_init(:aes_ctr, key, iv)
    {_new_state, plaintext} = :crypto.stream_decrypt(state, ciphertext)
    plaintext
  end

  @doc """
    Print the hash of the payload.  Right now its just the hash of the archive data. In the future
    we can wrap the archive in a structure with metadata and this hash can be used to prove that
    the data read was the intended data that was encrypted, proving fidelity of the process. (and
    then it can also be automatically compared.)
    ## Examples

      iex> PrivatePaper.print_hash 
      :ok

  """
  def print_hash(archive) do
    hash = :crypto.hash(:sha256, archive) |> Base.encode16(case: :lower)
    IO.puts("The archive's hash is: #{hash}")
    archive
  end

  @doc """
    Simple key derivation function.  This one concatenates the key and salt and hashes the
    result iteration times using SHA256, then returns the result in final hash. Calling with
    the same key and salt should produce the same final hash. This hash can be used as a key
    for encryption with increased entropy compared to a password. 
  
    ## Examples

      iex> PrivatePaper.kdf "password", "salt", 100 
      :ok

  """
  def kdf(key, salt, iterations) do
    IO.puts "Deriving a more secure key, this may take a minute."
    hash = :crypto.hash(:sha256, key <> salt)
    derived_key = accumulate_hash(hash, iterations)
    IO.puts("The derived key is: #{Base.encode16(derived_key, case: :lower)}")
    derived_key
  end

  def accumulate_hash(hash, iterations) when iterations <= 0 do
    hash
  end

  def accumulate_hash(hash, iterations) when iterations > 0 do
    accumulate_hash(:crypto.hash(:sha256, hash), iterations - 1)
  end

  def key_from_password(password) do
    salt = :crypto.hash(:sha256, password) |> Base.encode16(case: :lower)
    kdf(password, salt, 10000)
 end

  ##########################################################################
  ## QR ENCODING / DECODING
  ##########################################################################

  @doc """
    QR Encode the past in binary data.  Saves it to a file and uses porcelien to invoke a command
    line encoder, putting the result in the passed in file name.
    ## Examples

      iex> PrivatePaper.qr_encode("./test_data/qr_encoded/qrimage.png") 
      :ok

  """
  def qr_encode(data, destination) do
    File.write!("#{temp_directory()}/encoded_data.bin", data)
    IO.puts Porcelain.shell("ls -l #{temp_directory()}/encoded_data.bin").out
    IO.puts Porcelain.shell("cat #{temp_directory()}/encoded_data.bin | qrencode -o #{destination} -s 4 -l H -d 600 -8 ").out
    IO.puts Porcelain.shell("ls -l #{destination}").out
  end

  @doc """
    QR Decode the image file at the destination path. Return the raw data for decryption, etc.
    ## Examples

      iex> PrivatePaper.qr_decode("./test_data/qr_encoded/qrimage.png") 
      :ok

  """
  def qr_decode(image_file) do
    IO.puts Porcelain.shell("ls -l #{image_file}").out
    IO.puts Porcelain.shell("zbarimg #{image_file} -q  | cut -c 9- > #{temp_directory()}/decoded_data.bin").out
    File.read!("#{temp_directory()}/decoded_data.bin")
  end

  ##########################################################################
  ## UTILITIES
  ##########################################################################

  def temp_directory do
    "/tmp/privatepaper-working"
  end

end
