class RefundService
  include Serviceable

  def initialize(order, refund)
    @order = order
    @refund = refund
  end

  def call
    if @order.pay_channel == 'ali'
      ali_refund
    else
      wx_refund
    end
  end

  def ali_refund
    response = $alipay.execute(ali_params).encode('utf-8', 'gbk')
    result = JSON.parse(response)['alipay_trade_refund_response']
    if result['code'] == '10000' && result['fund_change'] == 'Y'
      return ApiResult.success_result
    end

    error_result(result['sub_msg'] || '退款系统有误，请核查')
  end

  def ali_params
    {
      method: 'alipay.trade.refund',
      biz_content: {
                out_trade_no: @order.order_number,
                out_request_no: @refund.out_refund_no,
                refund_amount: @refund.refund_price,
              }.to_json(ascii_only: true)
    }
  end

  def wx_refund
    result = WxPay::Service.invoke_refund(wx_params)
    Rails.logger.info("RefundService wx number=#{@refund.out_refund_no}: #{result}")
    unless WxPay::Sign.verify?(result[:raw]['xml'])
      return error_result('验证签名失败')
    end

    unless result.success?
      return error_result(result['err_code_des'])
    end

    ApiResult.success_result
  end

  def wx_params
    {
      out_refund_no: @refund.out_refund_no,
      refund_fee:    (@refund.refund_price * 100).to_i,
      out_trade_no:  @order.order_number,
      total_fee:     (@order.final_price * 100).to_i
    }
  end
end


