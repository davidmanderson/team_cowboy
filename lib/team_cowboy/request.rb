require 'faraday_middleware'
require 'digest/sha1'
require 'json'

module TeamCowboy
    module Request
      
      def get(method, data, options = {})
        params = build_params("GET", data.merge(method: method))
  
        response = connection(options).get do |req|
          req.params = params
          req.options.timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:timeout]
          req.options.open_timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:open_timeout]
        end
        handle_response response
      end
      
      def post(method, data, options = {})
        params = build_params("POST", data.merge(method: method))
        
        response = connection(options).post do |req|
          req.body = params
          req.options.timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:timeout]
          req.options.open_timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:open_timeout]
        end
        handle_response response
      end
      
      def put(method, data, options = {})
        params = build_params("PUT", data.merge(method: method))
  
        response = connection.put do |req|
          req.body = data.to_json
          req.options.timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:timeout]
          req.options.open_timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:open_timeout]
        end
        handle_response response
      end
      
      def delete(method, data, options = {})
        params = build_params("DELETE", data.merge(method: method))
  
        response = connection.delete do |req|
          req.params = params
          req.options.timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:timeout]
          req.options.open_timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:open_timeout]
        end
        handle_response response
      end

      def handle_response(response)
        begin 
          result = Hashie::Mash.new JSON.parse(response.body)
          result.success ? result.body : nil
        rescue Exception => e
          nil
        end
      end

      def generate_sig(method:, timestamp:, nonce:, params:)
        parts = [
          TeamCowboy.secret,
          method,
          params[:method],
          timestamp,
          nonce
        ]
        request_hash = {
          api_key: TeamCowboy.key,
          method: method,
          timestamp: timestamp,
          nonce: nonce
        }
        request_hash.merge!(params)
        
        request_array = []
        request_hash.keys.sort.each do |key|
          request_array.push "#{key.downcase}=#{ERB::Util.url_encode(request_hash[key].to_s).downcase}"
        end
        request_string = request_array.join('&')
        parts.push(request_string)
        
        Digest::SHA1.hexdigest parts.join('|')
      end

      def generate_nonce
        # generate a random 10 digit number
        rand((10**(10 - 1))..(10**10))
      end

      def generate_timestamp
        Time.now.getutc.to_i
      end
      
      def build_params(http_method, params={})
        timestamp = generate_timestamp
        nonce = generate_nonce

        params.merge(
          nonce: nonce,
          timestamp: timestamp,
          method: params[:method],
          api_key: TeamCowboy.key,
          sig: generate_sig(
            nonce: nonce,
            timestamp: timestamp,
            method: http_method,
            params: params
          )
        )
      end
  
      def connection(options = {})
        config = {
          :headers => {'Accept' => 'application/json', 'User-Agent' => user_agent},
        }
        config[:url] = options[:secure] ? "https://#{api_endpoint}" : "http://#{api_endpoint}"
        
        Faraday.new(config) do |builder|
          builder.request :url_encoded
          builder.adapter(adapter)
        end
      end
    end
  end