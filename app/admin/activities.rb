ActiveAdmin.register Activity do
  permit_params :title, :banner, :published, :description, :begin_time, :end_time, :view_increment, :intro

  filter :id
  filter :title
  filter :description

  form partial: 'form'

  index do
    render 'index', context: self
  end

  controller do
    before_action :process_doc, only: [:create, :update]
    before_action :unpublished?, only: [:destroy]

    def process_doc
      return if params[:doc].blank?

      params[:activity][:description] = DocProcessor.to_html(params[:doc].path)
    end

    def unpublished?
      return unless resource.published?

      flash[:error] = I18n.t('activity.destroy_error')
      redirect_back fallback_location: admin_hotels_url
    end
  end

  member_action :publish, method: :post do
    resource.publish!
    redirect_back fallback_location: admin_activities_url, notice: I18n.t('publish_notice')
  end

  member_action :unpublish, method: :post do
    resource.unpublish!
    redirect_back fallback_location: admin_activities_url, notice: I18n.t('unpublish_notice')
  end
end
