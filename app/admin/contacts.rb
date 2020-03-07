ActiveAdmin.register Contact do
  menu priority: 8, parent: 'APP设置', label: 'APP联系方式'
  config.batch_actions = false
  config.filters = false
  permit_params :mobile, :email

  index do
    column :id
    column :mobile, sortable: false
    column :email, sortable: false
    column :created_at, sortable: false
    actions
  end

  form partial: 'form'
end
