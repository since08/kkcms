ActiveAdmin.register HotelRefund do
  menu parent: '酒店管理'
  config.filters = false
  config.batch_actions = false
  actions :all, except: [:new, :edit, :create, :destroy]

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  action_item :agree_refund, only: :show do
    link_to '允许退款', agree_refund_admin_hotel_refund_url(resource), remote: true if resource.pending?
  end

  action_item :refuse_refund, only: :show do
    link_to '拒绝退款', refuse_refund_admin_hotel_refund_url(resource), remote: true if resource.pending?
  end

  member_action :agree_refund, method: [:get, :post] do
    return if request.get?

    if params[:confirm_code] != 'confirm'
      flash[:error] = '输入确认码有误'
      return redirect_to resource_url(resource)
    end

    result = HotelServices::AgreeRefund.call(resource)
    if result.failure?
      flash[:error] = result.msg
    else
      flash[:notice] = '退款成功'
    end
    redirect_to resource_url(resource)
  end

  member_action :refuse_refund, method: [:get, :post] do
    return if request.get?

    if params[:admin_memo].blank?
      flash[:error] = '拒绝原因不能为空'
    else
      resource.update(refund_status: 'refused', admin_memo: params[:admin_memo])
      flash[:notice] = '已拒绝退款'
    end

    redirect_to resource_url(resource)
  end
end
