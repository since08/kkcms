ActiveAdmin.register CheapPrizeCount do
  menu parent: '转盘', label: '小奖情况'
  config.batch_actions = false
  config.sort_order = 'date_desc'
  actions :all, except: [:new, :edit, :create, :destroy]

  filter :wheel_prize
  filter :date
end
