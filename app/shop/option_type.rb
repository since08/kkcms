module Shop
  ActiveAdmin.register OptionType, as: 'OptionType', namespace: :shop do
    config.batch_actions = false

    belongs_to :product, optional: true
    navigation_menu :default
    menu false
    actions :nil

    permit_params :name, :product_id

    controller do
      before_action :set_product, only: [:quick_new, :quick_create, :destroy]

      def changeable?
        !@product.order_items.exists?
      end

      def set_product
        @product = Product.find(params[:product_id])
      end
    end
    collection_action :quick_new, method: :get do
      if changeable?
        @option_type = OptionType.new(product: @product)
        render 'new', layout: false
      else
        render html: '已有相关联的订单，不允许改变该商品规格'
      end
    end

    collection_action :quick_create, method: :post do
      return unless changeable?

      @option_type = OptionType.new(permitted_params[:shop_option_type])
      @option_type.save
      render 'quick_response', layout: false
    end

    collection_action :destroy, method: :delete do
      if changeable?
        @option_type = OptionType.find(params[:id])
        has_values = @option_type.option_values.exists?
        @option_type.destroy
        @option_type.product.rebuild_variants_for_type_delete(has_values)
      else
        flash[:error] = '已有相关联的订单，不允许改变该商品规格'
      end
      redirect_back fallback_location: shop_product_variants_path(params[:product_id])
    end
  end
end
