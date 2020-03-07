ActiveAdmin.register Hotline do
  config.filters = false
  config.batch_actions = false
  config.sort_order = 'position_desc'
  scope :fast_food, default: true
  scope :public_service

  permit_params :title, :line_type, :telephone, :position
  form partial: 'form'
end
