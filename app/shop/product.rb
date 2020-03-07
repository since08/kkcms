module Shop
  ActiveAdmin.register Product, as: 'Product', namespace: :shop do
    config.batch_actions = false
    config.sort_order = 'position_desc'
    menu priority: 2

    filter :title
    filter :published
    filter :recommended
    filter :by_root_category_in, label: '主类别', as: :select, collection: Category.roots_collection

    permit_params :title, :description, :product_type, :category_id, :visible_discounts_list, :recommended,
                  :published, :returnable, :shipping_id, :intro, :product_type, :merchant_id,
                  master_attributes: [:original_price, :price, :stock,
                                      :volume, :origin_point, :weight]

    sidebar '侧边栏', only: [:edit, :update, :variants] do
      product_sidebar_generator(self)
    end

    form partial: 'form'

    index do
      render 'index', context: self
    end

    controller do
      def create
        position = Product.position_desc.first&.position.to_i + 100000
        @product = Product.new(permitted_params[:shop_product].merge(position: position))
        if @product.save
          flash[:notice] = '新建商品详情成功'
          redirect_to edit_shop_product_path(@product)
        else
          render :new
        end
      end

      def update
        @product = Product.find(params[:id])
        @product.assign_attributes(permitted_params[:shop_product])
        if @product.save
          flash[:notice] = '修改商品详情成功'
          redirect_to edit_shop_product_path(@product)
        else
          flash[:error] = '修改商品详情失败'
          render :edit
        end
      end

      def destroy
        if resource.order_items.exists?
          flash[:notice] = '已有相关联的订单，不允许删除商品'
        else
          resource.destroy
        end
        redirect_to shop_products_url
      end
    end

    member_action :publish, method: :post do
      Product.find(params[:id]).publish!
      redirect_back fallback_location: shop_products_url, notice: '上架商品成功'
    end

    member_action :unpublish, method: :post do
      Product.find(params[:id]).unpublish!
      redirect_back fallback_location: shop_products_url, notice: '已下架商品'
    end

    member_action :recommend, method: :post do
      Product.find(params[:id]).recommend!
      redirect_back fallback_location: shop_products_url, notice: '推荐商品成功'
    end

    member_action :unrecommend, method: :post do
      Product.find(params[:id]).unrecommend!
      redirect_back fallback_location: shop_products_url, notice: '已取消推荐商品'
    end

    member_action :reposition, method: :post do
      product = Product.find(params[:id])
      next_product = params[:next_id] && Product.find(params[:next_id].split('_').last)
      prev_product = params[:prev_id] && Product.find(params[:prev_id].split('_').last)
      position = if params[:prev_id].blank?
                   next_product.position + 100000
                 elsif params[:next_id].blank?
                   prev_product.position / 2
                 else
                   (prev_product.position + next_product.position) / 2
                 end
      product.update(position: position)
    end
  end
end