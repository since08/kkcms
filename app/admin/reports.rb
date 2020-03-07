ActiveAdmin.register Report do
  menu priority: 3, label: '举报管理', parent: '社交管理'
  actions :all, except: [:show, :new, :create]

  filter :target_type
  filter :user_nick_name, as: :string
  filter :body

  index do
    render 'index', context: self
  end

  member_action :ignore, method: :post do
    resource.ignored!
    redirect_back fallback_location: admin_reports_url, notice: '忽略成功'
  end

  controller do
    def scoped_collection
      super.where(ignored: false)
    end
  end
end
