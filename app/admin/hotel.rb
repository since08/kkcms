ActiveAdmin.register Hotel do
  menu parent: '酒店管理', label: '酒店列表'

  filter :id
  filter :title
  filter :location
  filter :published
  filter :region, as: :select, collection: Hotel::REGIONS_MAP.invert

  index do
    render 'index', context: self
  end

  permit_params :title, :logo, :location, :telephone, :description, :star_level,
                :amap_poiid, :region, :amap_location, :position
  form partial: 'form'

  show do
    render 'show', context: self
  end

  member_action :publish, method: :post do
    Hotel.find(params[:id]).publish!
    redirect_back fallback_location: admin_hotels_url, notice: I18n.t('publish_notice')
  end

  member_action :unpublish, method: :post do
    Hotel.find(params[:id]).unpublish!
    redirect_back fallback_location: admin_hotels_url, notice: I18n.t('unpublish_notice')
  end

  member_action :reposition, method: :post do
    hotel = Hotel.find(params[:id])
    next_hotel = params[:next_id] && Hotel.find(params[:next_id].split('_').last)
    prev_hotel = params[:prev_id] && Hotel.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_hotel.position + 100000
               elsif params[:next_id].blank?
                 prev_hotel.position / 2
               else
                 (prev_hotel.position + next_hotel.position) / 2
               end
    hotel.update(position: position)
  end
  
  collection_action :amap_detail, method: :get do
    response = Faraday.get('https://restapi.amap.com/v3/place/detail',
                key: ENV['AMAP_KEY'],
                id: params[:poiid])
    pois = JSON.parse(response.body)['pois']
    @poi = pois.presence ? pois[0] : {}
  end

  controller do
    before_action :unpublished?, only: [:destroy]
    before_action :set_position, only: [:create]
    before_action :process_doc, only: [:create, :update]

    def process_doc
      return if params[:doc].blank?

      params[:hotel][:description] = DocProcessor.to_html(params[:doc].path)
    end

    def unpublished?
      return unless resource.published?

      flash[:error] = I18n.t('hotel.destroy_error')
      redirect_back fallback_location: admin_hotels_url
    end

    def set_position
      params[:hotel][:position] = Hotel.position_desc.first&.position.to_i + 100000
    end

    def apply_sorting(chain)
      params[:order] ? chain : chain.reorder(published: :desc, position: :desc)
    end
  end

  sidebar '侧边栏', only: [:show, :edit] do
    hotel_sidebar_generator(self)
  end
end
