module HotelServices
  class AgreeRefund
    include Serviceable

    def initialize(refund)
      @refund = refund
      @order = refund.hotel_order
    end

    def call
      return error_result('状态不是待审核中，不允许操作') unless @refund.pending?
      
      return error_result('订单未付款，不允许退款') if @order.unpaid?

      return error_result('该订单已退款') if @order.refunded?

      return error_result('超出了可退款金额') if refundable_price_over?

      return error_result('已超过入住时间，不允许退款') if over_checkin_date?

      result = RefundService.call(@order, @refund)
      return result if result.failure?

      refund_coupon
      reduce_integral
      @refund.completed!
      @order.update(status: 'refunded', refund_price: @refund.refund_price)
      update_sales_room
      ApiResult.success_result
    end

    # 退款成功，修改每日房间已卖出的数量
    def update_sales_room
      @order.room_items.each do |item|
        next if item['price_id'].blank?

        room_price = HotelRoomPrice.find(item['price_id'])
        room_price.decrease_sales(@order.room_num)
        room_price.sale_room_request&.to_refund
      end
    end

    def refund_coupon
      @order.coupon && @order.coupon.update(coupon_status: 'refund', refund_time: Time.now)
    end

    def reduce_integral
      Integral.create_refund_to_integral(user: @order.user,
                                         target: @order,
                                         price: @order.final_price,
                                         option_type: @order.model_name.singular)
    end

    def refundable_price_over?
      @refund.refund_price > @order.final_price
    end

    def over_checkin_date?
      Time.now > @order.checkin_date + 1.day
    end
  end
end
