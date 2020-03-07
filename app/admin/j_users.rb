ActiveAdmin.register JUser do
  menu priority: 1, parent: '用户管理', label: '极光用户'
  config.batch_actions = false
  actions :all, except: [:new, :destroy, :edit]

  filter :user_nick_name, as: :string
  filter :user_user_uuid, as: :string
  filter :created_at

  index do
    column 'Id', :id
    column :user_id do |resource|
      link_to resource.user.user_uuid, admin_user_url(resource.user), target: '_blank'
    end
    column :nick_name do |resource|
      resource.user.nick_name
    end
    column :created_at
    actions name: '操作', defaults: false do |resource|
      item '删除', delete_user_admin_j_user_path(resource), method: :post, data: { confirm: '确定删除吗？' }
    end
  end

  member_action :delete_user, method: [:post] do
    resource.delete_user
    redirect_back fallback_location: admin_j_users_url, notice: '删除成功'
  end
end
