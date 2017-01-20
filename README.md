# Private Paper
    
Archive your secrets without compromising them.

Secure storage of digital info on paper. 

Encoding:
- Takes a directory of files tars them with compression
- Encrypts the files with your public key
- (Optional) Reed Soloman or other ECC code added
- (Future) Splits file into chunks which are one page in size
- Wraps chunk with metadata (eg: order, hashes)
- Generates PDF with all of the chunks. 

Decoding:
- Reverses the above

How to get it working:
======================
(need to be on a mac at this point)
```
brew install elixir
brew install zbar
brew install qrencode
mix escript.build
./PrivatePaper
```

## Not done yet:
- Take command line parameters
- Get a best practices key derivation function implemented
- Support multi-page archives
- Wrap archive in metadata and implement a HMAC

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `PrivatePaper` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:PrivatePaper, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/PrivatePaper](https://hexdocs.pm/PrivatePaper).




