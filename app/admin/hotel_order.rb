ActiveAdmin.register HotelOrder do
  menu parent: '酒店管理'
  actions :all, except: [:new, :edit, :create, :destroy]

  filter :user_email_or_user_mobile, as: :string
  filter :order_number

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  member_action :confirm, method: :post do
    order = HotelOrder.find(params[:id])
    order.confirmed! if order.paid?
    redirect_back fallback_location: admin_hotel_orders_url, notice: '确认成功'
  end

  member_action :unconfirm, method: :post do
    order = HotelOrder.find(params[:id])
    order.paid! if order.confirmed?
    redirect_back fallback_location: admin_hotel_orders_url, notice: '取消确认成功'
  end

  action_item :confirm, only: :show do
    link_to '确认有房', confirm_admin_hotel_order_url(resource), method: :post if resource.paid?
  end

  action_item :unconfirm, only: :show do
    link_to '取消确认有房', unconfirm_admin_hotel_order_url(resource), method: :post if resource.confirmed?
  end
end
