module Qcloud
  module SmsGateway
    class Remote
      attr_accessor :conn, :response

      def initialize
        self.conn = Faraday.new(url: remote_path) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
      end

      def self.post(uri, params = {})
        new.post(uri, params)
      end

      def post(uri, params = {})
        self.response = conn.post do |req|
          req.url uri
          req.options.timeout = 5
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json
        end
        parse_body
      end

      def parse_body
        JSON.parse response.body
      end

      def remote_path
        'https://yun.tim.qq.com'
      end
    end
  end
end