ActiveAdmin.register SaleRoomRequest do
  menu parent: '商家管理', label: '房间挂售'
  config.batch_actions = false
  config.filters = false
  config.clear_action_items!

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  member_action :new_refuse, method: :get

  member_action :refuse, method: :post do
    if resource.pending?
      resource.update(refused_memo: params[:refused_memo], status: 'refused')
    end
    redirect_back fallback_location: admin_sale_room_requests_url
  end

  member_action :pass, method: :post do
    if resource.pending?
      resource.update(passed_time: Time.now, status: 'passed')
      resource.create_room_price
    end
    redirect_back fallback_location: admin_sale_room_requests_url
  end
end