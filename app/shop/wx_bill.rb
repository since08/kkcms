ActiveAdmin.register WxBill, namespace: :shop do
  config.batch_actions = false
  config.clear_action_items!
  menu priority: 3, parent: '订单管理'

  index do
    id_column
    column(:user) { |bill| link_to bill.order.user.nick_name, admin_user_path(bill.order.user_id) }
    column(:order_number) { |bill| link_to bill.order.order_number, shop_order_path(bill.order_id) }
    column(:transaction_id)
    column(:pay_success)
    column(:total_fee) { |bill| bill.wx_result['total_fee'].to_f / 100 }
    column(:fee_type) { |bill| bill.wx_result['fee_type'] }
    column(:time_end) { |bill| bill.wx_result['time_end'] }
    column(:trade_type) { |bill| bill.wx_result['trade_type'] }
    column(:source_type)
  end
end
