module Shop
  ActiveAdmin.register Order, as: 'Order', namespace: :shop do
    config.breadcrumb = false
    menu priority: 3, parent: '订单管理', label: '订单列表'
    actions :all, except: [:new, :edit, :create, :destroy]

    scope :all, default: 'true'
    scope :unpaid
    scope :paid
    scope :delivered
    scope :completed
    scope :canceled

    filter :user_email_or_user_mobile, as: :string
    filter :order_number

    member_action :cancel, method: [:get, :post] do
      return render :cancel if request.get?

      reason = params[:cancel_reason]
      resource.cancel_order reason
      redirect_back fallback_location: shop_orders_url
    end

    member_action :shipping_detail, method: :get do
      render :shipping_detail
    end

    index download_links: false do
      render 'index'
    end

    show do
      render 'show'
    end
  end
end
