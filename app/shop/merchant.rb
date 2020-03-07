module Shop
  ActiveAdmin.register Merchant, as: 'Merchant', namespace: :shop do
    config.batch_actions = false

    permit_params :name, :telephone, :amap_poiid, :amap_location, :location
    form partial: 'form'

    index do
      render 'index', context: self
    end

    collection_action :amap_detail, method: :get do
      response = Faraday.get('https://restapi.amap.com/v3/place/detail',
                             key: ENV['AMAP_KEY'],
                             id: params[:poiid])
      pois = JSON.parse(response.body)['pois']
      @poi = pois.presence ? pois[0] : {}
    end
  end
end