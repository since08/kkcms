ActiveAdmin.register Sauna do
  menu priority: 3, parent: '资讯管理', label: '桑拿'

  filter :title
  filter :location
  filter :published

  index do
    render 'index', context: self
  end

  permit_params :title,  :logo, :location, :telephone, :description, :star_level,
                :amap_poiid, :amap_location, :position, :price, :published, :longitude, :latitude
  form partial: 'form'

  show do
    render 'show', context: self
  end

  member_action :publish, method: :post do
    resource.publish!
    redirect_back fallback_location: admin_saunas_url, notice: I18n.t('publish_notice')
  end

  member_action :unpublish, method: :post do
    resource.unpublish!
    redirect_back fallback_location: admin_saunas_url, notice: I18n.t('unpublish_notice')
  end

  member_action :reposition, method: :post do
    sauna = resource
    next_sauna = params[:next_id] && Sauna.find(params[:next_id].split('_').last)
    prev_sauna = params[:prev_id] && Sauna.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_sauna.position + 100000
               elsif params[:next_id].blank?
                 prev_sauna.position / 2
               else
                 (prev_sauna.position + next_sauna.position) / 2
               end
    sauna.update(position: position)
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

    def unpublished?
      return unless resource.published?

      flash[:error] = I18n.t('sauna.destroy_error')
      redirect_back fallback_location: admin_saunas_url
    end

    def set_position
      params[:sauna][:position] = Sauna.position_desc.first&.position.to_i + 100000
    end

    def apply_sorting(chain)
      params[:order] ? chain : chain.reorder(published: :desc, position: :desc)
    end
  end

  sidebar '侧边栏', only: [:show, :edit] do
    sauna_sidebar_generator(self)
  end
end
