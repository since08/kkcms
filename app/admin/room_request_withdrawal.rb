ActiveAdmin.register RoomRequestWithdrawal do
  menu parent: '商家管理', label: '房间提现'
  config.batch_actions = false
  config.filters = false
  config.clear_action_items!

  index do
    render 'index', context: self
  end

  member_action :pass, method: :post do
    if resource.pending?
      resource.update(status: 'passed')
      resource.sale_room_request.update(is_withdrawn: true, withdrawn_time: Time.now)
      resource.merchant_user.increase_withdrawal_amount(resource.price)
    end
    redirect_back fallback_location: admin_room_request_withdrawals_url
  end

end