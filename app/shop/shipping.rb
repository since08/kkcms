module Shop
  ActiveAdmin.register Shipping, as: 'Shipping', namespace: :shop do
    config.batch_actions = false
    config.filters = false

    permit_params :name, :express_id, :calc_rule
    form partial: 'form'

    index do
      render 'index', context: self
    end

    show do
      render 'show', context: self
    end

    controller do
      before_action :shipping_used?, only: [:destroy]

      def shipping_used?
        return if resource.products.blank?

        flash[:error] = '已有商品使用该运费模板，不允许删除'
        redirect_back fallback_location: shop_expresses_url
      end
    end
  end
end

