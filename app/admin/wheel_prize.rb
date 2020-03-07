ActiveAdmin.register WheelPrize do
  menu parent: '转盘', label: '转盘奖品'
  config.batch_actions = false
  config.filters = false

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  permit_params :name, :prize_type, :limit_per_day, :generation_rule, :wheel_element_id, :image, :face_value, :description
  form partial: 'form'
end
