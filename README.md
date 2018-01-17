# Pigman Classic
Minecraft Classic server in Scheme (protocol version 0x07). Very incomplete currently.

## Usage
1. Get dependencies
2. Run `make`
3. Run `./pigmanclassic`

## Dependencies
These can all be found in [the egg index](http://wiki.call-cc.org/chicken-projects/egg-index-4.html), and installed by typing `sudo chicken-install [egg]`
* `r7rs` (R7RS compatibility)
* `tcp-server` (server)
* `byte-blob` (handling byte arrays)
* `z3` (gzip compression)
