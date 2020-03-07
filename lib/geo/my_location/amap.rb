module Geo
  module MyLocation
    class Amap < Base
      KEY = ENV['AMAP_KEY'].freeze
      URL = 'http://restapi.amap.com/v3/place/around?'.freeze

      def genarate_url(params)
        URL + {
          key: KEY,
          location: params[:location],
          page: params[:page],
          keywords: params[:keyword],
          radius: params[:radius] || 1000,
          types: params[:keyword] || '080307|100000|110000|120000' # 赌场／酒店／风景名胜／商业建筑
        }.to_query
      end

      def parse_response(response)
        pois = JSON.parse(response.body)&.[]('pois') || []
        {
          base: {
            geo_type: 'amap',
            cityname: (pois[0]['cityname'] if pois.present?)
          },
          nearbys: pois.map do |x|
            latitude, longitude = x['location'].split(',')
            {
              name: x['name'],
              address: x['address'],
              latitude: latitude.to_f,
              longitude: longitude.to_f
            }
          end
        }
      end
    end
  end
end
