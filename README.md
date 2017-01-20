# Private Paper
    
Archive your secrets without compromising them.

Secure storage of digital info on paper. 

# Why?

For some data, paper, or physical media is the ideal format for long term storage. For example, 
nuclear launch codes, bitcoin private keys, the password that unlocks all your other passwords, etc.

Every form of storage for this kind of information has tradeoffs.  Computers can store a lot with great 
fidelity, but they can be compromised, and over time they will become obsolete. The popular digital storage
formats of only a few years ago are now difficult to read. (hard drive interface standards have changed, few 
people have zip drives anymore, for instance.)

Physical storage can be retained for centuries, possibly longer if the image is etched on metal. Further it is
easy to make multiple redundant copies of a form of storage such as paper.

But paper, and other physical mediums generally can be read by anyone who posesses them.

Private Paper is a compromise between the two.  The fidelity and ease of digital information, with the longetivity
of a physical medium like paper, but with a bit of security. 

Your data is encrypted using an AES 256 Stream Cipher with a password you provide.  Hence, Private Paper.

# Method

Process:
- Takes a directory of files tars them with compression 
- Encrypts the files with a secure key derived from your password
- Reed Soloman or other ECC code added. (Right now hashes are generated, and QR has reed solomon at low levels)
- (Future) Splits file into chunks which are one page in size
- (Future) Wraps chunks with metadata (eg: order, hashes) for ensuring fidelity
- Generates image with the QR code.

Decoding:
- Reverses the above

Note: Currently using command line QR encoder and decoder, which are meant for very short QR codes (eg: URLS) and the decoder is mangling them into ascii.  Need to find good QR codec.

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
- Good QR Codec that works for larger amounts of binary data and doesn't convert to ASCII.
- Take command line parameters
- Get a best practices key derivation function implemented
- Support multi-page archives
- Wrap archive in metadata and implement a HMAC




