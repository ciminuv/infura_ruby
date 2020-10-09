# InfuraRuby

Ruby gem to wrap the [INFURA](https://github.com/ethereum/wiki/wiki/JSON-RPC) API which gives HTTP API access to ethereum and IPFS nodes. The API uses the same format as the [JSON RPC spec](https://github.com/ethereum/wiki/wiki/JSON-RPC) for normal ethereum nodes.

## Usage

__Installation__
```bash
gem install infura_ruby
```

```ruby
require 'infura_ruby'

# create a client object
infura = InfuraRuby.client(api_key: key)

# get the balance of an address
infura.call('eth_getBalance', ['0x81F631b8615EaB75d38DaC4d4bce4A5b63e10310', 'latest'])
