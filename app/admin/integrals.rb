ActiveAdmin.register Integral do
  menu priority: 5, parent: '积分管理', label: '积分明细'
  config.batch_actions = false
  config.clear_action_items!
  config.sort_order = 'active_at_desc'

  filter :user_nick_name, as: :string
  filter :mark

  index do
    render 'index', context: self
  end
end
