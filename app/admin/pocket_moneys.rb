ActiveAdmin.register PocketMoney do
  menu priority: 5, parent: '钱包管理'
  config.breadcrumb = false
  actions :all, except: [:new, :edit, :destroy]
  config.sort_order = 'created_at_desc'

  filter :user_nick_name, as: :string
  filter :user_mobile, as: :string
  filter :option_type, as: :select

  index do
    render 'index', context: self
  end
end
