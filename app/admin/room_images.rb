ActiveAdmin.register AdminImage, as: 'RoomImage' do
  config.filters = false
  belongs_to :hotel_room

  config.clear_action_items!

  permit_params :image
  controller do
    before_action :set_room

    def new
      @image = @room.images.build
    end

    def create
      @image = @room.images.build(permitted_params[:admin_image])
      flash[:notice] = '新建成功' if @image.save
      render 'response'
    end

    def destroy
      @img = @room.images.find(params[:id])
      @img.destroy
      flash[:notice] = '删除图片成功'
      redirect_to admin_hotel_hotel_room_url(@room.hotel, @room)
    end

    def set_room
      @room = HotelRoom.find(params[:hotel_room_id])
    end
  end
end
