ActiveAdmin.register User do
  menu priority: 1, parent: '用户管理', label: 'app用户'

  actions :all, except: [:destroy, :edit]

  permit_params :mark, :nick_name, :email, :password, :level_special
  config.sort_order = 'last_visit_desc'

  filter :user_uuid
  filter :nick_name
  filter :mobile
  filter :email
  filter :reg_date

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  sidebar :'数量统计', only: :index do
    ul do
      li "用户总数：#{User.count}个"
      li "1级用户总数: #{UserRelation.where(level: 1).count}"
      li "2级用户总数: #{UserRelation.where(level: 2).count}"
      li "3级用户总数: #{UserRelation.where(level: 3).count}"
      li "直接邀请成功数: #{UserCounter.sum(:direct_invite_count)}"
      li "间接邀请成功数: #{UserCounter.sum(:indirect_invite_count)}"
    end
  end

  form partial: 'form'

  controller do
    def scoped_collection
      User.includes(:counter)
    end

    def create
      email = user_params[:email]
      password = user_params[:password]
      if !UserValidator.email_valid?(email) || password.blank? || UserValidator.email_exists?(email)
        return redirect_back fallback_location: admin_users_url, notice: '用户创建失败，请检查邮箱是否重复，格式是否正确!'
      end
      password_md5 = ::Digest::MD5.hexdigest(password)
      user = User.create_by_email(email, password_md5)
      UserRelation.create({ user: user, level: 0, new_user: false })
      user.update(new_user: false)
      redirect_back fallback_location: admin_users_url, notice: '用户创建成功'
    end

    def user_params
      params.require(:user).permit(:email,
                                   :password)
    end
  end

  member_action :profile, method: :get

  member_action :followers, method: :get do
    @page_title = "粉丝列表(共计#{resource.followers_count})"
    @followers = resource.follow_by_users.page(params[:page])
  end

  member_action :followings, method: :get do
    @page_title = "关注列表(共计#{resource.following_count})"
    @followings = resource.follow_users.page(params[:page])
  end

  member_action :block, method: [:post] do
    resource.update(blocked: true, blocked_at: Time.zone.now)
    render 'update_success'
  end

  member_action :invites, method: :get do
    relation_users = UserRelation.where("pid = ? or gid = ?", resource.id, resource.id)
    relation_count = relation_users.count
    @relation_users=  relation_users.order(created_at: :desc).page(params[:page])
    @page_title = "邀请列表(邀请总数: #{relation_count}, 个人邀请数: #{resource.counter.invite_users}, 成功总数#{resource.counter.direct_invite_count}, 下级成功总数#{resource.counter.indirect_invite_count})"
  end

  member_action :unblock, method: [:post] do
    resource.update(blocked: false, blocked_at: Time.zone.now)
    render 'update_success'
  end

  member_action :silence_user, method: [:get, :post] do
    return render :silence unless request.post?
    resource.silenced!(params[:silence_reason], params[:silence_till])
    render 'update_success'
  end

  collection_action :search_mobile_user, method: [:get] do
    @user = User.by_mobile(params[:mobile])
    render 'user_info'
  end

  collection_action :search_user_modal, method: :get do
    render 'search_user_modal'
  end

  action_item :invite_awards, only: :index do
    link_to '分销奖励', admin_invite_awards_path
  end
end
