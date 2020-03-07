ActiveAdmin.register Visa do
  menu priority: 8, parent: 'APP设置', label: '签证内容设置'
  config.batch_actions = false
  config.filters = false
  permit_params :description

  form partial: 'form'
end
