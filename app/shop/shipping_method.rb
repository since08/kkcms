module Shop
  ActiveAdmin.register ShippingMethod, as: 'ShippingMethod', namespace: :shop do
    config.batch_actions = false
    config.filters = false

    belongs_to :shipping
    permit_params :first_item, :first_price, :add_item, :add_price, :default_method, :name
    form partial: 'form'

    index do
      render 'index', context: self
    end

    controller do
      before_action :set_shipping, only: [:new, :create, :edit, :update]
      before_action :set_method, only: [:edit, :update]

      def new
        @method = @shipping.shipping_methods.build
        render 'new'
      end

      def create
        @method = @shipping.shipping_methods.build(permitted_params[:shop_shipping_method])
        flash[:notice] = '新建运费方式成功' if @method.save
        render 'response'
      end

      def edit
        render 'new'
      end

      def update
        @method.assign_attributes(permitted_params[:shop_shipping_method])
        flash[:notice] = '更新成功' if @method.save
        render 'response'
      end

      def set_shipping
        @shipping = Shipping.find(params[:shipping_id])
      end

      def destroy
        resource.destroy
        flash[:notice] = '删除成功'
        redirect_to shop_shipping_url(params[:shipping_id])
      end

      def set_method
        @method = @shipping.shipping_methods.find(params[:id])
      end
    end

    member_action :new_regions, method: :get

    member_action :regions, method: :post do
      if params[:regions].present?
        regions = params[:regions].values
        @method = ShippingMethod.find(params[:id])
        @method.shipping_regions.destroy_all

        regions.each do |region|
          shipping_region = @method.shipping_regions.build(region_name: region['name'],
                                                           code: region['code'],
                                                           shipping_id: @method.shipping_id)
          shipping_region.save
        end
      end
    end
  end
end