require "json"
require "uri"
require "forwardable"

require "beaconpush/client"
require "beaconpush/response_error"

module Beaconpush
  class << self
    extend Forwardable
    attr_accessor :key, :secret
    attr_writer :version, :host, :port
    def_delegators :client, :users_count, :user_online?, :user_logout, :user_message, :channel_message, :channel_users

    def host
      @host ||= "beaconpush.com"
    end

    def port
      @port ||= 80
    end

    def version
      @version ||= "1.0.0"
    end

    def client
      @client ||= Client.new(:key => key, :secret => secret, :version => version, :host => host, :port => port)
    end
  end
end
