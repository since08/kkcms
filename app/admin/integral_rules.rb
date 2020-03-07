ActiveAdmin.register IntegralRule do
  menu priority: 5, parent: '积分管理', label: '积分规则'
  permit_params :option_type_alias, :option_type, :limit_times, :points, :opened, :icon, :position
  config.filters = false
  config.batch_actions = false
  actions :all, except: [:show, :destroy]
  config.sort_order = 'position_asc'

  index do
    render 'index', context: self
  end

  form partial: 'form'

  member_action :reposition, method: :post do
    next_integral = params[:next_id] && IntegralRule.find(params[:next_id].split('_').last)
    prev_integral = params[:prev_id] && IntegralRule.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_integral.position / 2
               elsif params[:next_id].blank?
                 prev_integral.position + 100000
               else
                 (prev_integral.position + next_integral.position) / 2
               end
    resource.update(position: position)
  end
end
