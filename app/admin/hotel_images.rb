ActiveAdmin.register AdminImage, as: 'Image' do
  config.filters = false
  belongs_to :hotel

  sidebar '侧边栏', only: [:index] do
    hotel_sidebar_generator(self)
  end

  config.clear_action_items!
  action_item :add, only: :index do
    link_to '新增图片', new_admin_hotel_image_path(hotel), remote: true
  end

  index do
    render 'admin/hotels/images/index', context: self
  end

  permit_params :image
  controller do
    before_action :set_hotel, only: [:new, :create]
    skip_before_action :verify_authenticity_token, only: [:create]

    def new
      @image = @hotel.images.build
      render 'admin/hotels/images/new'
    end

    def create
      @image = @hotel.images.build(permitted_params[:admin_image])
      flash[:notice] = '新建成功' if @image.save
      render 'admin/hotels/images/response'
    end

    def set_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end
  end
end
