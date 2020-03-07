ActiveAdmin.register Reply do
  menu false

  member_action :delete_reply, method: [:get, :post] do
    return render :delete unless request.post?
    resource.update(deleted_reason: params[:reason], deleted_at: Time.zone.now)
    redirect_back fallback_location: admin_comments_url, notice: '删除成功'
  end
end
