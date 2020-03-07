ActiveAdmin.register ExchangeTrader do
  menu parent: '外汇管理'
  config.filters = false
  config.sort_order = 'score_desc'
  scope :ex_rate, default: true
  scope :integral
  scope :dating

  permit_params :user_id, :score, :memo, :trader_type
  form partial: 'form'

  index do
    render 'index', context: self
  end
end
