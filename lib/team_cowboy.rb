require 'faraday'
require 'hashie'
require "team_cowboy/version"
require 'team_cowboy/client'
require 'team_cowboy/configuration'

module TeamCowboy
  extend Configuration
  
  mattr_accessor :key, :secret
  
  # Alias for TeamCowboy::Client.new
  #
  # @return [TeamCowboy::Client]
  def self.new(options={})
    TeamCowboy::Client.new(options)
  end

  # Delegate to TeamCowboyClient::Client
  def self.method_missing(method, *args, &block)
    return super unless new.respond_to?(method)
    new.send(method, *args, &block)
  end
end
