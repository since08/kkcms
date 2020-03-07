module Shop
  ActiveAdmin.register Image, as: 'Image', namespace: :shop do
    config.batch_actions = false
    config.filters = false
    config.paginate = false
    config.sort_order = 'position_asc'

    config.clear_action_items!
    action_item :add, only: :index do
      link_to '新增图片', new_shop_product_image_path(product), remote: true
    end

    belongs_to :product

    sidebar '侧边栏' do
      product_sidebar_generator(self)
    end

    permit_params :crop_x, :crop_y, :crop_w, :crop_h, :image

    index title: '图片管理', download_links: false do
      render 'shop/products/images/index', context: self
    end

    form partial: 'shop/products/images/form'

    controller do
      before_action :set_product, only: [:new, :create, :edit, :update]
      before_action :set_image, only: [:edit, :update]

      def new
        @image = @product.images.build
        render 'shop/products/images/new'
      end

      def create
        last_img = @product.images.position_asc.last
        position = last_img&.position.to_i + 100000
        @image = @product.images.build(permitted_params[:shop_image].merge(position: position))
        flash[:notice] = '新建成功' if @image.save
        render 'shop/products/images/response'
      end

      def edit
        render 'shop/products/images/new'
      end

      def update
        @image.assign_attributes(permitted_params[:shop_image])
        flash[:notice] = '更新成功' if @image.save
        render 'shop/products/images/response'
      end

      def set_product
        @product = Product.find(params[:product_id])
      end

      def set_image
        @image = @product.images.find(params[:id])
      end
    end

    member_action :reposition, method: :post do
      blind = Image.find(params[:id])
      next_blind = params[:next_id] && Image.find(params[:next_id].split('_').last)
      prev_blind = params[:prev_id] && Image.find(params[:prev_id].split('_').last)
      position = if params[:prev_id].blank?
                   next_blind.position / 2
                 elsif params[:next_id].blank?
                   prev_blind.position + 100000
                 else
                   (prev_blind.position + next_blind.position) / 2
                 end
      blind.update(position: position)
    end
  end
end