ActiveAdmin.register HotelRoomPrice, as: 'RoomPrice' do
  config.batch_actions = false
  config.filters = false
  config.sort_order = 'date_asc'
  breadcrumb do
    path = edit_admin_hotel_hotel_room_path(hotel_room.hotel, hotel_room)
    breadcrumb_links(path)
  end

  belongs_to :hotel_room
  permit_params :date, :price, :dates, :room_num_limit
  controller do
    before_action :set_room
    before_action :set_price, only: [:edit, :update, :destroy]

    def new
      @room_price = @room.prices.build
    end

    def create
      if price_params[:dates].blank?
        @room_price = @room.prices.create(price_params.merge(hotel_id: @room.hotel_id))
      else
        create_for_dates
      end
      render 'response'
    end

    def create_for_dates
      failed_dates = []
      price_params[:dates].split(/,|，/).each do |date|
        price = @room.prices.create(hotel_id: @room.hotel_id, date: date, price: price_params[:price], room_num_limit: price_params[:room_num_limit])
        next if price.errors.blank?
        failed_dates << date
      end
      if failed_dates.present?
        flash[:error] = "这批日期创建失败：#{failed_dates.join(', ')}"
      end
      # 为了 @room_price.errors为空
      @room_price = HotelRoomPrice.new
    end

    def edit
      render 'new'
    end

    def update
      @room_price.assign_attributes(price_params)
      flash[:notice] = '更新成功' if @room_price.save
      render 'response'
    end

    def destroy
      @room_price.destroy
      flash[:notice] = '删除特定价格成功'
      redirect_to admin_hotel_hotel_room_url(@room.hotel, @room)
    end

    def set_room
      @room = HotelRoom.find(params[:hotel_room_id])
    end

    def set_price
      @room_price = @room.prices.find(params[:id])
    end

    def price_params
      permitted_params[:hotel_room_price]
    end
  end
end
