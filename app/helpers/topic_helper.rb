module TopicHelper
  def select_to_status(topic)
    select_tag :status, options_for_select(AdminTrans::TRANS_TOPIC_STATUSES, topic.status),
               data: { before_val: topic.status, url: change_status_admin_topic_path(topic) },
               class: 'ajax_change_status'
  end

  def full_image(image)
    image.gsub(/!sm$/, '')
  end

  def body_filter_nbsp(body)
    body.gsub(/&nbsp/, '&nbsp;')
  end
end