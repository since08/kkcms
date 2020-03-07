module Shop
  ActiveAdmin.register OneYuanBuy, as: 'OneYuanBuy', namespace: :shop do
    config.batch_actions = false
    # config.clear_action_items!
    config.remove_action_item(:new)

    permit_params :product_id, :begin_time, :end_time, :saleable_num, :sales_volume,
                  :published, :viewable

    form partial: 'form'

    index do
      render 'index', context: self
    end
  end
end