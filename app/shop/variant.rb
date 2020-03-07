module Shop
  ActiveAdmin.register Variant, as: 'Variant', namespace: :shop do
    config.batch_actions = false
    config.filters = false

    belongs_to :product
    navigation_menu :default
    menu false
    actions :update

    sidebar '侧边栏' do
      product_sidebar_generator(self)
    end

    permit_params :price, :original_price, :stock, :weight, :volume,
                  image_attributes: [:crop_x, :crop_y, :crop_w, :crop_h, :image]

    controller do
      before_action :set_product, only: [:index, :quick_edit]
      before_action :set_variant, only: [:quick_edit, :quick_update, :update]
      after_action :update_all_stock, only: [:update]

      def update_all_stock
        @variant.product.recount_all_stock
      end

      def update
        @variant.update(permitted_params[:shop_variant])
      end

      def set_product
        @product = Product.find(params[:product_id])
      end

      def set_variant
        @variant = Variant.find(params[:id])
      end
    end

    action [], :index, method: :get do
      render layout: 'layouts/active_admin'
    end

    member_action :quick_edit, method: :get do
      render layout: false
    end

    member_action :quick_update, method: :patch do
      @variant.update(permitted_params[:shop_variant])
      @variant.product.recount_all_stock
      render 'quick_response', layout: false
    end
  end
end