ActiveAdmin.register ViewRule do
  menu priority: 22
  permit_params :day, :interval, :min_increase, :max_increase, :hot
  config.sort_order = 'day_asc hot_desc'

  index do
    column :day
    column(:interval) { |i| best_in_place i, :interval, as: 'input', place_holder: '点我添加', url: [:admin, i] }
    column(:min_increase) { |i| best_in_place i, :min_increase, as: 'input', place_holder: '点我添加', url: [:admin, i] }
    column(:max_increase) { |i| best_in_place i, :max_increase, as: 'input', place_holder: '点我添加', url: [:admin, i] }
    column :hot
    actions
  end

  show do
    render 'show', context: self
  end
end
