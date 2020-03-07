module Geo
  module MyLocation
    class Base
      def self.search(params)
        new.search(params)
      end

      def search(params)
        response = RestClient::Request.execute(method: :get, url: genarate_url(params))
        parse_response(response)
      end

      private

      def genarate_url(params); end

      def parse_response(response); end
    end
  end
end
