require 'team_cowboy/configuration'
require File.expand_path('../request', __FILE__)

module TeamCowboy
  class Client

    # @private
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    # Creates a new Client
    def initialize(options={})
      options = TeamCowboy.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end
    
    def consume(request, options = {})
      unless options[:validate] == false
        if !validate(request)
          puts "Incorrect signature"
          return
        end
      end
      
      result = Hashie::Mash.new(request.params)
      result[result.keys.first] unless result.blank?
    end
    
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}
    
    alias :api_endpoint :endpoint

    
    include Request
    include Auth
    include User
    include Team
    include Event
  end
end