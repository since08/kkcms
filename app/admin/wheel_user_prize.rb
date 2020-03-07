ActiveAdmin.register WheelUserPrize do
  menu parent: '转盘', label: '用户中奖情况'
  config.batch_actions = false
  actions :all, except: [:new, :edit, :create, :destroy]

  filter :user_nick_name, as: :string
  filter :user_mobile, as: :string
  filter :wheel_prize
  filter :is_expensive
  filter :used
  filter :prize_type, as: :select, collection: AdminTrans::WHEEL_PRIZE_TYPES

  index do
    render 'index', context: self
  end

  member_action :use_prize, method: [:get, :post] do
    return if request.get?

    resource.update(used: true, used_time: Time.current, used_memo: params[:used_memo])
    redirect_to admin_wheel_user_prizes_url
  end

  member_action :giving_cash, method: :post do
    unless resource.used
      resource.update(used: true, used_time: Time.current, used_memo: '后台确认发放大奖红包')
      PocketMoney.create_wheel_pocket_money(user: resource.user,
                                            target: resource,
                                            amount: resource.wheel_prize.face_value)
    end

    redirect_back fallback_location: admin_wheel_user_prizes_url, notice: '发放成功'
  end
end
