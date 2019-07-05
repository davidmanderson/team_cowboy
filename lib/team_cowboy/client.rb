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

    def as(user_token)
      tc = TeamCowboy.new
      tc.user_token = user_token
      tc
    end
    
    
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}
    
    alias :api_endpoint :endpoint

    
    include Request
    include Auth
    include User
    include Team
    include Event
    include Message
    include Test
  end
end