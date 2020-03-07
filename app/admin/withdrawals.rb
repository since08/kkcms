ActiveAdmin.register Withdrawal do
  menu priority: 2, parent: '钱包管理'
  config.breadcrumb = false
  actions :all, except: [:new, :edit, :destroy]
  config.sort_order = 'created_at_desc'

  filter :user_nick_name, as: :string
  filter :user_mobile, as: :string
  filter :real_name
  filter :option_status, as: :select, collection: AdminTrans::WITHDRAWAL_OPTION_STATUS
  filter :account_type, as: :select, collection: AdminTrans::WITHDRAWAL_ACCOUNT_TYPE
  filter :account_memo
  filter :created_at

  index do
    render 'index', context: self
  end

  batch_action :'批量提现通过', confirm: '确定操作吗?' do |ids|
    error_ids = []
    Rails.logger.info "batch_action success-> #{current_admin_user&.email}操作的id: #{ids}"
    Withdrawal.find(ids).each do |item|
      error_ids << item.id unless item.option_status.eql?('pending')
      item.admin_change_status('success', current_admin_user&.email)
    end
    Rails.logger.info "batch_action success-> 失败的id: #{error_ids}"
    redirect_back fallback_location: admin_withdrawals_url, notice: "操作成功！状态修改失败ids: #{error_ids}"
  end

  batch_action :'批量提现失败', confirm: '确定操作吗?' do |ids|
    error_ids = []
    Rails.logger.info "batch_action success-> #{current_admin_user&.email}操作的id: #{ids}"
    Withdrawal.find(ids).each do |item|
      error_ids << item.id unless item.option_status.eql?('pending')
      item.admin_change_status('failed', current_admin_user&.email)
    end
    Rails.logger.info "batch_action success-> 失败的id: #{error_ids}"
    redirect_back fallback_location: admin_users_url, notice: "操作成功！状态修改失败ids: #{error_ids}"
  end
end
