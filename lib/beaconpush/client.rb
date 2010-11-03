module Beaconpush
  class Client
    attr_accessor :api_key, :secret_key, :version, :host, :port

    def initialize(options)
      self.api_key = options.fetch(:api_key, Beaconpush.api_key) || raise(ArgumentError, "No API key given")
      self.secret_key = options.fetch(:secret_key, Beaconpush.secret_key) || raise(ArgumentError, "No secret key given")
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
      path = "/api/#{version}/#{api_key}#{URI.encode(command)}"

      request = Net::HTTPGenericRequest.new(method.to_s.upcase, !!body, method.to_s.upcase != "HEAD", path)

      if body
        request.body = body
        request.content_length = body.size
      end

      request["X-Beacon-Secret-Key"] = secret_key

      response = http.request(request)

      if (200...300).include?(response.code.to_i)
        JSON.parse(response.body) if response.body and response.body != ""
      else
        raise ResponseError.new(response)
      end
    end
  end
end
