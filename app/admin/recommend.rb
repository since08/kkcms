ActiveAdmin.register Recommend do
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
      position = Recommend.position_desc.first&.position.to_i + 100000
      @recommend = Recommend.new recommend_params.merge(position: position)

      if @recommend.save
        flash[:notice] = '新建Recommend成功'
        redirect_to admin_recommends_url
      else
        render :new
      end
    end

    def recommend_params
      params.require(:recommend).permit(:image, :source_id, :source_type)
    end
  end

  member_action :reposition, method: :post do
    recommend = Recommend.find(params[:id])
    next_recommend = params[:next_id] && Recommend.find(params[:next_id].split('_').last)
    prev_recommend = params[:prev_id] && Recommend.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_recommend.position + 100000
               elsif params[:next_id].blank?
                 prev_recommend.position / 2
               else
                 (prev_recommend.position + next_recommend.position) / 2
               end
    recommend.update(position: position)
  end
end