#Private Paper
    
Archive your secrets without compromising them.

Secure storage of digital info on paper. 

Encoding:
- Takes a directory of files tars them with compression
- Encrypts the files with your public key
- (Optional) Reed Soloman or other ECC code added
- Splits file into chunks which are one page in size
- Wraps chunk with metadata (eg: order, hashes)
- Generates PDF with all of the chunks. 

Decoding:
- Reverses the above