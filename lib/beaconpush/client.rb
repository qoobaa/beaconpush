require "net/http"

module Beaconpush
  class Client
    attr_accessor :key, :secret, :version, :host, :port

    def initialize(options)
      self.key = options.fetch(:key, Beaconpush.key) || raise(ArgumentError, "No key given")
      self.secret = options.fetch(:secret, Beaconpush.secret) || raise(ArgumentError, "No secret given")
      self.version = options.fetch(:version, Beaconpush.version) || raise(ArgumentError, "No API version given")
      self.host = options.fetch(:host, Beaconpush.host) || raise(ArgumentError, "No Beacon host given")
      self.port = options.fetch(:port, Beaconpush.port) || raise(ArgumentError, "No Beacon port given")
    end

    def users_count
      request("GET", "/users")["online"]
    end

    def user_online?(user)
      request("GET", "/users/#{user}")
      true
    rescue ResponseError => e
      (e.response.code.to_i == 404) ? false : raise
    end

    def user_logout(user)
      request("DELETE", "/users/#{user}")
    end

    def user_message(user, message)
      request("POST", "/users/#{user}", message.to_json)["messages_sent"]
    end

    def channel_message(channel, message)
      request("POST", "/channels/#{channel}", message.to_json)["messages_sent"]
    end

    def channel_users(channel)
      request("GET", "/channels/#{channel}")["users"]
    end

    private

    def http
      Net::HTTP.new(host, port)
    end

    def request(method, command, body = nil)
      path = "/api/#{version}/#{key}#{URI.encode(command)}"

      request = Net::HTTPGenericRequest.new(method.to_s.upcase, !!body, method.to_s.upcase != "HEAD", path)

      if body
        request.body = body
        request.content_length = body.size
      end

      request["X-Beacon-Secret-Key"] = secret

      response = http.request(request)

      if (200...300).include?(response.code.to_i)
        JSON.parse(response.body) if response.body and response.body != ""
      else
        raise ResponseError.new(response)
      end
    end
  end
end
