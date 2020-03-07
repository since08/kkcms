ActiveAdmin.register WheelCount do
  menu parent: '转盘', label: '转盘用户统计'
  config.sort_order = 'updated_at_desc'
  config.clear_action_items!
  config.filters = false

  index do
    render 'index', context: self
  end

  sidebar :'转盘总的统计', only: :index do
    ul do
      li "转盘总次数: #{WheelCount.total.first.lottery_times}次"
      li "转盘总用户数: #{WheelUserPrize.select(:user_id).distinct.count}"
    end
  end

  controller do
    def scoped_collection
      super.daily
    end
  end
end
