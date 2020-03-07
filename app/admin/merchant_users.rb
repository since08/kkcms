ActiveAdmin.register MerchantUser do
  menu parent: '商家管理', label: '商家用户'

  actions :all, except: [:new, :destroy, :edit]
  permit_params :mark

  config.sort_order = 'last_visit_desc'

  filter :user_uuid
  filter :nick_name
  filter :mobile
  filter :created_at

  index do
    render 'index', context: self
  end
end
