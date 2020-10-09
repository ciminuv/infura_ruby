require 'faraday'
require 'json'

module InfuraRuby
  class Client
    class InfuraCallError < StandardError; end
    class InvalidEthereumAddressError < StandardError; end

    ETHEREUM_ADDRESS_REGEX = /^0x[0-9a-fA-F]{40}$/

    NETWORK_URLS = {
      main:         'https://mainnet.infura.io/v3',
      ropsten:      'https://ropsten.infura.io/v3',
      kovan:        'https://kovan.infura.io/v3',
      rinkeby:      'https://rinkeby.infura.io/v3'
    }.freeze

    def initialize(api_key:, network: :main)
      validate_api_key(api_key)
      validate_network(network)

      @api_key = api_key
      @network = network
    end

    def call(method, params)
      resp = conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = json_rpc(method: method, params: params).to_json
      end
      resp_body  = JSON.parse(resp.body)

      if resp_body['error']
        raise InfuraCallError.new(
          "Error (#{resp_body['error']['code']}): Infura API call "\
          "#{method} gave message: '#{resp_body['error']['message']}'"
        )
      else
        resp_body['result']
      end
    end

    private

    def json_rpc(method:, params:)
      {
        'jsonrpc' => '2.0',
        'method'  => method,
        'params'  => params,
        'id'      => 1
      }
    end

    def conn
      @conn ||= Faraday.new(
        url: "#{NETWORK_URLS[@network]}/#{@api_key}",
      )
    end

    def validate_api_key(api_key)
      raise InvalidApiKeyError unless /^[a-zA-Z0-9]{32}$/ =~ api_key
    end

    def validate_network(network)
      raise InvalidNetworkError if NETWORK_URLS[network].nil?
    end
  end
end
