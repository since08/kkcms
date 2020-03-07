ActiveAdmin.register Express, namespace: :shop do
  config.batch_actions = false
  config.filters = false

  permit_params :name, :code

  controller do
    before_action :deletable?, only: [:destroy]

    def deletable?
      return if resource.shipments.blank?

      flash[:error] = '该类型下有相应的物流信息，不允许删除'
      redirect_back fallback_location: shop_expresses_url
    end
  end
end
