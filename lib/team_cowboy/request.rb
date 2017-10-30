require 'faraday_middleware'
require 'digest/sha1'

module TeamCowboy
    module Request
      
      # Perform an HTTP GET request
      def get(resource_path, params = {})
        request = construct_request(resource_path, params)
  
        response = connection.get do |req|
          req.url request[:url], request[:params]
          req.options = request_options
        end
        Hashie::Mash.new(response.body)
      end
      
      def post(resource_path, params)
        request = construct_request(resource_path, "POST", params)
        
        r = response = connection.post do |req|
          req.url request[:url], request[:params]
          #binding.pry
          #req.params = request[:params]
          req.body = request[:params]
          req.options.timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:timeout]
          req.options.open_timeout = Configuration::DEFAULT_REQUEST_OPTIONS[:open_timeout]
        end
        
        binding.pry
        Hashie::Mash.new(response.body)
      end
      
      def put(resource_path, data)
        request = construct_request(resource_path)
  
        response = connection.put do |req|
          req.url request[:url]
          req.body = data.to_json
          req.options = request_options
        end
        Hashie::Mash.new(response.body)
      end
      
      def delete(resource_path)
        request = construct_request(resource_path)
  
        response = connection.delete do |req|
          req.url request[:url]
          req.options = request_options
        end
        Hashie::Mash.new(response.body)
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
          request_array.push "#{key}=#{request_hash[key]}"
        end
        request_string = request_array.join('&')
        parts.push(request_string)

        value = Digest::SHA1.hexdigest parts.join('|')
        binding.pry
        value
      end

      def generate_nonce
        rand(10 ** 8)
      end

      def generate_timestamp
        Time.now.getutc.to_i
      end
      
      def construct_request(resource_path, method, params={})
        timestamp = generate_timestamp
        nonce = generate_nonce

        new_params = params.merge(
          nonce: nonce,
          timestamp: timestamp,
          method: params[:method],
          api_key: TeamCowboy.key,
          sig: generate_sig(
            nonce: nonce,
            timestamp: timestamp,
            method: method,
            params: params
          )
        )
        #binding.pry
        request = {}
        request[:url] = "#{Configuration::DEFAULT_ENDPOINT}/#{resource_path}"
        request[:params] = new_params
        request    
      end
  
      def connection
        options = {
          :headers => {'Accept' => 'application/json', 'User-Agent' => user_agent},
          :url => api_endpoint,
        }
        
        Faraday.new(options) do |builder|
          #builder.request  :json
          builder.request :url_encoded
          builder.adapter(adapter)
        end
      end
    end
  end