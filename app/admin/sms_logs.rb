ActiveAdmin.register SmsLog do
  menu priority: 20
  config.batch_actions = false
  config.clear_action_items!
  config.sort_order = 'send_time_desc'

  filter :mobile
  filter :status
  filter :send_time

  index do
    id_column
    column :mobile
    column :content do |i|
      i.content.gsub(/\d{6}/, '******')
    end
    column :error_msg
    column :fee
    column :send_time
    column :arrival_time
    column :status
  end
end
