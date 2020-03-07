ActiveAdmin.register Banner do
  menu parent: '首页管理'
  config.batch_actions = false
  config.filters = false
  config.sort_order = 'position_desc'

  form partial: 'form'

  index do
    render 'index', context: self
  end

  controller do
    def create
      position = Banner.position_desc.first&.position.to_i + 100000
      @banner = Banner.new banner_params.merge(position: position)

      if @banner.save
        flash[:notice] = '新建banner成功'
        redirect_to admin_banners_url
      else
        render :new
      end
    end

    def banner_params
      params.require(:banner).permit(:image,
                                     :source_id,
                                     :source_type)
    end
  end

  member_action :reposition, method: :post do
    banner = Banner.find(params[:id])
    next_banner = params[:next_id] && Banner.find(params[:next_id].split('_').last)
    prev_banner = params[:prev_id] && Banner.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_banner.position + 100000
               elsif params[:next_id].blank?
                 prev_banner.position / 2
               else
                 (prev_banner.position + next_banner.position) / 2
               end
    banner.update(position: position)
  end
end