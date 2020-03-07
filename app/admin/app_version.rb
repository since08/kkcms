ActiveAdmin.register AppVersion do
  menu priority: 8, parent: 'APP设置', label: 'APP版本管理'
  config.batch_actions = false
  config.filters = false

  permit_params :platform, :version, :force_upgrade, :title, :content, :download_url
  form partial: 'form'

  index do
    column :platform
    column :version
    column :title
    column :force_upgrade
    column :download_url
    actions
  end
end
