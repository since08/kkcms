ActiveAdmin.register ExpensivePrizeCount do
  menu parent: '转盘', label: '大奖情况'
  config.batch_actions = false
  config.sort_order = 'id_desc'
  actions :all, except: [:new, :edit, :create, :destroy]

  filter :wheel_prize

  index do
    column :id
    column :wheel_prize
    column :current_user_num
    column :is_giving
    column :created_at
  end
end
