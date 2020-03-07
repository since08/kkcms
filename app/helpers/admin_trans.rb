module AdminTrans
  EXCHANGE_TYPES = ExchangeRate.rate_types.keys.collect { |d| [I18n.t("exchange_rate.#{d}"), d] }

  PRODUCT_TYPES = Shop::Product.product_types.keys.collect { |d| [I18n.t("product.#{d}"), d] }

  SHIPPING_RULES = Shop::Shipping.calc_rules.keys.collect { |d| [I18n.t("shipping.#{d}"), d] }

  SOURCE_TYPES = %w[hotel info].collect { |d| [I18n.t("banner.#{d}"), d] }

  TRANS_TOPIC_STATUSES = Topic.statuses.keys.collect { |d| [I18n.t("status.#{d}"), d] }

  COUPON_TYPE = CouponTemp.coupon_types.keys.collect { |d| [I18n.t("coupon_type.#{d}"), d] }

  DISCOUNT_TYPE = CouponTemp.discount_types.keys.collect { |d| [I18n.t("discount_type.#{d}"), d] }

  TRADER_TYPES = ExchangeTrader.trader_types.keys.collect { |d| [I18n.t("trader_type.#{d}"), d] }

  HOTLINE_TYPES = Hotline.line_types.keys.collect { |d| [I18n.t("hotline_type.#{d}"), d] }

  WITHDRAWAL_ACCOUNT_TYPE = %w[alipay bank].collect { |d| [I18n.t("withdraw_type.#{d}"), d] }

  WITHDRAWAL_OPTION_STATUS = %w[pending success failed].collect { |d| [I18n.t("withdraw_status.#{d}"), d] }

  WHEEL_PRIZE_TYPES = WheelPrize.prize_types.keys.collect { |d| [I18n.t("prize_type.#{d}"), d] }
end
