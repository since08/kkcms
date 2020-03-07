ActiveAdmin.register Shipment, namespace: :shop do
  belongs_to :order
  menu false

  controller do
    before_action :set_order, only: [:new, :create, :edit, :update]
    before_action :set_shipment, only: [:edit, :update]

    def new
      @shipment = Shipment.new(order: @order)
    end

    def edit; end

    def update
      @shipment.update!(shipment_params)
    end

    def create
      return render :repeat_error if @order.shipment.present?

      @shipment = Shipment.new(shipment_params.merge(order: @order))
      @order.deliver! if @shipment.save
    end

    def set_order
      @order = Shop::Order.find(params[:order_id])
    end

    def set_shipment
      @shipment = Shipment.find(params[:id])
    end

    def shipment_params
      params.require(:shipment).permit(:express_id,
                                       :express_number)
    end
  end
end