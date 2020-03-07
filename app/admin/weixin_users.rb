ActiveAdmin.register WeixinUser do
  menu priority: 1, parent: '用户管理', label: '微信用户'
  config.batch_actions = false
  config.clear_action_items!

  filter :user_id, as: :string
  filter :open_id
  filter :nick_name
  filter :province
  filter :city
  filter :created_at

  index do
    id_column
    column :open_id
    column :head_img do |wx_user|
      avatar(wx_user.head_img, size: 80)
    end
    column :nick_name
    column :user do |wx_user|
      if wx_user.try(:user).present?
        link_to wx_user.user.nick_name, admin_user_url(wx_user.user), target: '_blank'
      end
    end
    column :sex do |wx_user|
      wx_user.sex.to_i.eql?(1) ? '男' : '女'
    end
    column :province
    column :city
    column :created_at
  end
end
