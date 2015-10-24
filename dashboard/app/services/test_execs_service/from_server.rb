require 'http'
require 'json'
require 'uri'

module TestExecsService
  class FromServer < Base
    @server_address = URI::HTTP.build({
      :host => 'localhost',
      :port => ENV[SIS_TEST_SERVER_PORT_ENV].to_i
    }).to_s

    def self.execute
      make_post_request URI.join(@server_address, 'execute')
    end

    def self.status(uuid)
      status_request = URI.join(@server_address, 'status/', uuid.to_s)
      response_body = make_get_request status_request
      unless response_body.nil?
        json_hash = JSON.parse response_body
        return TestExec.new(uuid, json_hash['status'], json_hash['counters'])
      end
    end

    def self.all_uuids
      JSON.parse HTTP.get(@server_address).body.to_s
    end

    private

    def self.make_get_request(request)
      response = HTTP.get request
      unless response.status_code >= 300
        response.body.to_s
      end
    end

    def self.make_post_request(request)
      response = HTTP.post request
      if response.status_code >= 300
        return nil
      end
      response.body.to_s
    end

  end
end