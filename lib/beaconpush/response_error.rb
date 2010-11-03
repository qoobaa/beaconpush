module Beaconpush
  class ResponseError < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
      super(message)
    end

    def message
      JSON.parse(response.body.to_s)["message"] rescue "Server responded with an error"
    end
  end
end
