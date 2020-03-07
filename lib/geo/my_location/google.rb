module Geo
  module MyLocation
    class Google < Base
      KEY = ENV['GOOGLE_KEY'].freeze
      URL = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'.freeze

      def genarate_url(params)
        URL + {
          key: KEY,
          location: params[:location],
          radius: params[:radius] || 1000,
          keyword: params[:keyword],
          pagetoken: params[:pagetoken]
        }.to_query
      end

      def parse_response(response)
        body = JSON.parse(response.body) || {}
        {
          base: {
            geo_type: 'google',
            next_page_token: body['next_page_token']
          },
          nearbys: body['results'].map do |x|
            {
              name: x['name'],
              address: x['vicinity'],
              latitude: x['geometry']['location']['lat'],
              longitude: x['geometry']['location']['lng']
            }
          end
        }
      end
    end
  end
end
