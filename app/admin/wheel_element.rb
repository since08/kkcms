ActiveAdmin.register WheelElement do
  menu parent: '转盘', label: '转盘组成元素'
  config.batch_actions = false
  config.filters = false
  config.sort_order = 'position_desc'

  index do
    render 'index', context: self
  end

  permit_params :name, :image, :position
end
