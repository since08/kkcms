ActiveAdmin.register InfoType do
  config.filters = false
  menu priority: 3, parent: '资讯管理', label: '资讯类别'
  permit_params :name, :slug, :published

  index do
    column :name, sortable: false
    column :slug, sortable: false
    column :published, sortable: false
    actions
  end

  controller do
    before_action :deletable?, only: [:destroy]

    def deletable?
      return if resource.infos.blank?

      flash[:error] = '该类型下有相应的资讯，不允许删除'
      redirect_back fallback_location: admin_info_types_url
    end
  end
end
