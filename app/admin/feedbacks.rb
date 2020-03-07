ActiveAdmin.register Feedback do
  config.batch_actions = false
  config.filters = false
  config.clear_action_items!

  index do
    column :id
    column '用户名称' do |resource|
      resource.user&.nick_name
    end
    column :content
    column :contact
    column :dealt
    column :created_at
    actions defaults: false do |resource|
      if resource.dealt
        item '取消处理', deal_admin_feedback_path(resource), method: :post
      else
        item '确认处理', deal_admin_feedback_path(resource), method: :post
      end
    end
  end

  member_action :deal, method: :post do
    feedback = Feedback.find(params[:id])
    feedback.update(dealt: !feedback.dealt)
    redirect_back fallback_location: admin_feedbacks_url, notice: '操作成功'
  end
end
