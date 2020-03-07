ActiveAdmin.register InviteAward do
  menu false
  config.batch_actions = false
  config.filters = false

  permit_params :direct_award, :indirect_award, :published

  index do
    render 'index', context: self
  end

  member_action :publish, method: :post do
    resource.publish!
    redirect_back fallback_location: admin_invite_awards_url, notice: I18n.t('publish_notice')
  end

  member_action :unpublish, method: :post do
    resource.unpublish!
    redirect_back fallback_location: admin_invite_awards_url, notice: I18n.t('unpublish_notice')
  end
end
