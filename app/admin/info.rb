ActiveAdmin.register Info do
  menu priority: 3, parent: '资讯管理', label: '资讯列表'

  filter :id
  filter :title
  filter :info_type
  filter :published
  filter :stickied

  permit_params :title, :date, :image, :published, :description, :view_increment, :info_type_id, :coupon_ids, :audio_link, :intro
  form partial: 'form'

  show do
    render 'show', context: self
  end

  index do
    render 'index', context: self
  end

  controller do
    before_action :unpublished?, only: [:destroy]
    before_action :process_doc, only: [:create, :update]
    before_action :process_coupon_ids, only: [:create, :update]

    def process_doc
      return if params[:doc].blank?

      params[:info][:description] = DocProcessor.to_html(params[:doc].path)
    end

    def process_coupon_ids
      coupon_ids = params[:info][:coupon_ids]&.split(/,\s*|，\s*/)
      return if coupon_ids.blank?
      params[:info][:coupon_ids] = coupon_ids.join(',')
    end

    def unpublished?
      return unless resource.published?

      flash[:error] = I18n.t('info.destroy_error')
      redirect_back fallback_location: admin_hotels_url
    end
  end

  member_action :publish, method: :post do
    Info.find(params[:id]).publish!
    redirect_back fallback_location: admin_infos_url, notice: I18n.t('publish_notice')
  end

  member_action :unpublish, method: :post do
    Info.find(params[:id]).unpublish!
    redirect_back fallback_location: admin_infos_url, notice: I18n.t('unpublish_notice')
  end

  member_action :sticky, method: :post do
    info = Info.find(params[:id])
    info.info_type.infos.stickied.update(stickied: false)
    info.sticky!
    redirect_back fallback_location: admin_infos_url, notice: I18n.t('sticky_notice')
  end

  member_action :unsticky, method: :post do
    Info.find(params[:id]).unsticky!
    redirect_back fallback_location: admin_infos_url, notice: I18n.t('unsticky_notice')
  end

  member_action :views, method: [:get, :post] do
    view_toggle = resource.view_toggle
    unless request.post?
      @common_view_toggle = view_toggle.present? ? view_toggle : ViewToggle.new
      return render :toggle_view
    end
    on_off = params[:on_off].eql?('on') ? true : false
    hot = params[:type].eql?('hot') ? true : false
    # 判断之前是否有保存过
    create_params = { target: resource,
                      toggle_status: on_off,
                      hot: hot,
                      begin_time: Time.zone.now,
                      last_time: Time.zone.now }
    view_toggle.present? ? view_toggle.update(create_params) : ViewToggle.create(create_params)
    redirect_back fallback_location: admin_infos_url, notice: '更改成功'
  end

  member_action :likes, method: [:get, :post] do
    return if request.get?
    User.where(r_level: 0).shuffle.take(params[:number].to_i).each do |user|
      # 如果用户点赞过了 就不用再次点赞了
      next if user.find_action(:like, target: resource).present?
      user.create_action(:like, target: resource)
      user.dynamics.create(option_type: 'like', target: resource)
    end
    redirect_back fallback_location: admin_infos_url, notice: '创建成功'
  end

  member_action :people_likes, method: :get do
    @page_title = "点赞列表 (#{resource.likes_count})"
    @like_by_users = resource.like_by_users.page(params[:page])
  end
end
