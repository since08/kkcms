module Geo
  class Location
    def self.nearby(latitude, longitude, options = {})
      if options[:geo_type] == 'google'
        location = "#{latitude},#{longitude}"
        ::Geo::MyLocation::Google.search(options.merge(location: location))
      else
        location = "#{longitude},#{latitude}"
        ::Geo::MyLocation::Amap.search(options.merge(location: location))
      end
    end
  end
end
