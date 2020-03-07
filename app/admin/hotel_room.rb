ActiveAdmin.register HotelRoom do
  config.filters = false
  config.batch_actions = false

  belongs_to :hotel

  show do
    render 'show', context: self
  end

  permit_params :title, :hotel_id, :text_tags, :text_notes, :published, :room_num_limit
  form partial: 'form'

  controller do
    before_action :process_params, only: [:create, :update]
    before_action :set_hotel, only: [:create, :update]
    before_action :set_hotel_room, only: [:create, :update]
    before_action :check_week_prices_params, only: [:create, :update]
    after_action  :update_min_wday_prices, only: [:destroy]

    def create
      if @hotel_room.save
        update_wday_prices
        update_min_wday_prices if @hotel_room.published
        redirect_to resource_path(@hotel_room)
      else
        flash[:error] = '创建失败'
        render :new
      end
    end

    def update
      if @hotel_room.update(permitted_params[:hotel_room])
        HotelRoomPrice.where(hotel_room_id: @hotel_room.id, is_master: true).delete_all
        update_wday_prices
        update_min_wday_prices
        redirect_to resource_path(@hotel_room)
      else
        flash[:error] = '更新失败'
        render :new
      end
    end

    def update_wday_prices
      week_prices_params.each do |wday, price|
        @hotel_room.wday_prices.create(wday: wday, price: price,
                                       hotel_id: @hotel.id,
                                       room_num_limit: @hotel_room.room_num_limit)
      end
    end

    def update_min_wday_prices
      HotelRoomPrice::WDAYS.each { |wday| update_min_wday_price(wday) }
    end

    # 更新酒店一周七天的最低价格
    def update_min_wday_price(wday)
      wday_price = @hotel.wday_min_price(wday)
      @hotel.update("#{wday}_min_price": wday_price.price)
    end

    def check_week_prices_params
      week_prices_params.as_json.each_value do |price|
        if price.to_f <= 0
          flash.now[:error] = '一周七天的价格不能为0元或空'
          return render :new
        end
      end
    end

    def process_params
      # 将中文的逗号转成英文的
      params[:hotel_room][:text_tags].gsub!('，', ',')
      params[:hotel_room][:text_notes].gsub!('，', ',')
    end

    def week_prices_params
      @week_prices_params ||= params[:hotel_room][:week_prices]
    end

    def set_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end

    def set_hotel_room
      @hotel_room = params[:id] ? HotelRoom.find(params[:id]) : HotelRoom.new(permitted_params[:hotel_room])
    end

    def strict_sync_price(source_room_prices, target_room, is_cover)
      source_room_prices.each do |source_price|
        target_price = target_room.prices.find_by(date: source_price.date, sale_room_request_id: nil)
        # 如果不覆盖而且已存在price则跳过
        next if is_cover.to_i == 0 && target_price.present?

        if target_price.present?
          target_price.update(price: source_price.price, room_num_limit: source_price.room_num_limit)
        else
          target_room.prices.create(hotel_id: target_room.hotel_id,
                                    date: source_price.date,
                                    price: source_price.price,
                                    room_num_limit: source_price.room_num_limit)
        end
      end
    end
  end

  member_action :sync_prices, method: :post do
    target_rooms = HotelRoom.where(hotel_id: resource.hotel_id, id: params[:hotel][:sync_rooms])
    source_room_prices = resource.prices.where('date >= ?', Date.current).where(sale_room_request_id: nil)
    target_rooms.each do |target_room|
      strict_sync_price(source_room_prices, target_room, params[:hotel][:is_cover])
    end
    redirect_back fallback_location: admin_hotel_hotel_room_path(resource.hotel_id, resource), notice: '同步房间价格成功，操作人请确认相应房间的价格'
  end

  member_action :new_sync_prices, method: :get do
    @rooms_collection = resource.hotel.hotel_rooms.order(id: :desc).map do |room|
      next if room.id === resource.id

      checked = room.published && !room.title.match('特价')
      ["#{ room.published ? '已上架' : '未上架'} - #{room.title}", room.id , { checked: checked }]
    end.compact
  end
end
