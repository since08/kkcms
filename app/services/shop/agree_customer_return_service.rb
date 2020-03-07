module Shop
  class AgreeCustomerReturnService
    include Serviceable

    def initialize(customer_return)
      @c_return = customer_return
      @order = customer_return.order
    end

    def call
      return error_result('状态不是待审核中，不允许操作') unless @c_return.pending?
      return error_result('订单未付款，不允许退换货') if @order.unpaid?

      send("process_#{@c_return.return_type}")
    end

    # 如果是换货类型直接确认成功
    def process_exchange_goods
      complete_return!
      ApiResult.success_result
    end

    def process_refund
      return error_result('超出了可退款金额') if refundable_price_over?

      result = RefundService.call(@order, @c_return)
      return result if result.failure?

      complete_return!
      calc_order_refunded_price!
      restock_when_undelivered
      reduce_integral
      ApiResult.success_result
    end

    def refundable_price_over?
      @c_return.refund_price > @order.refundable_price
    end

    def complete_return!
      @c_return.completed!
      @c_return.return_items.each(&:completed!)
    end

    # 计算该订单已退款的的金额并标记相应的order_item 的已退款状态为true
    def calc_order_refunded_price!
      @order.update(refunded_price: @order.refunded_price + @c_return.refund_price)
      @c_return.return_items.each { |item| item.order_item.update(refunded: true) }
    end

    # 未发货的时候，恢复库存
    def restock_when_undelivered
      return if @order.delivered?

      @c_return.return_items.each do |item|
        variant = item.order_item.variant
        variant.increase_stock(item.order_item.number)
        next if variant.is_master?

        variant.product.master.increase_stock(item.order_item.number)
      end
    end

    def reduce_integral
      Integral.create_refund_to_integral(user: @order.user,
                                         target: @order,
                                         price: @c_return.refund_price,
                                         option_type: @order.model_name.singular)
    end
  end
end
