ActiveAdmin.register Coupon do
  menu priority: 3, parent: '优惠券', label: '列表'
  config.clear_action_items!
  config.sort_order = 'receive_time_desc'

  filter :coupon_number
  filter :user_id

  index do
    render 'index', context: self
  end

  batch_action :'批量删除', confirm: '确定操作吗?' do |ids|
    Coupon.find(ids).each do |item|
      item.destroy if item.receive_time.blank?
    end
    redirect_back fallback_location: admin_coupons_url, notice: "操作成功！"
  end

  batch_action :destroy, false

  member_action :award, method: [:get, :post] do
    return render :award unless request.post?
    user = User.by_mobile(params[:mobile])
    if user&.mobile.present?
      resource.received_by_user(user)
      resource.update(mark: "由用户#{current_admin_user&.email}发放")
      redirect_back fallback_location: admin_coupons_url, notice: '发放成功'
    else
      redirect_back fallback_location: admin_coupons_url, notice: '发放失败'
    end
  end
end
