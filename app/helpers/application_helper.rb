module ApplicationHelper
  def img_link_to_show(resource, preview = nil)
    image = preview || resource.preview_logo
    # link_to resource.logo.url ? image_tag(resource.preview_logo, height: 150) : '', resource_path(resource)
    link_to image_tag(image, height: 150), resource_path(resource)
  end

  def hotel_sidebar_generator(context)
    context.instance_eval do
      ul do
        li link_to '酒店详情', admin_hotel_path(hotel)
        li link_to '酒店房间管理', admin_hotel_hotel_rooms_path(hotel)
        li link_to '酒店图片管理', admin_hotel_images_path(hotel)
      end
    end
  end

  def hotel_publish_link(hotel)
    if hotel.published?
      link_to I18n.t('unpublish'), unpublish_admin_hotel_path(hotel), method: :post
    else
      link_to I18n.t('publish'), publish_admin_hotel_path(hotel), method: :post
    end
  end

  def sauna_publish_link(sauna)
    if sauna.published?
      link_to I18n.t('unpublish'), unpublish_admin_sauna_path(sauna), method: :post
    else
      link_to I18n.t('publish'), publish_admin_sauna_path(sauna), method: :post
    end
  end

  def sauna_sidebar_generator(context)
    context.instance_eval do
      ul do
        li link_to '详情', admin_sauna_path(sauna)
        li link_to '图片管理', admin_sauna_sauna_images_path(sauna)
      end
    end
  end

  def info_publish_link(info)
    if info.published?
      link_to I18n.t('unpublish'), unpublish_admin_info_path(info), method: :post
    else
      link_to I18n.t('publish'), publish_admin_info_path(info), method: :post
    end
  end

  def coupon_temp_publish_link(coupon_temp)
    if coupon_temp.published?
      link_to I18n.t('unpublish'), unpublish_admin_coupon_temp_path(coupon_temp), method: :post
    else
      link_to I18n.t('publish'), publish_admin_coupon_temp_path(coupon_temp), method: :post
    end
  end

  def activity_publish_link(activity)
    if activity.published?
      link_to I18n.t('unpublish'), unpublish_admin_activity_path(activity), method: :post
    else
      link_to I18n.t('publish'), publish_admin_activity_path(activity), method: :post
    end
  end

  def invite_award_publish_link(resource)
    if resource.published?
      link_to I18n.t('unpublish'), unpublish_admin_invite_award_path(resource), method: :post
    else
      link_to I18n.t('publish'), publish_admin_invite_award_path(resource), method: :post
    end
  end

  def info_sticky_link(info)
    if info.stickied?
      link_to I18n.t('unsticky'), unsticky_admin_info_path(info), method: :post
    else
      link_to I18n.t('sticky'), sticky_admin_info_path(info), method: :post
    end
  end

  def avatar(src, options = {})
    html_options = { class: 'img-circle', size: 60 }.merge(options)
    image_tag(src.presence || 'default_avatar.jpg', html_options)
  end

  def avatar_profile(user, options = {})
    avatar_path = user.avatar_path.presence || 'default_avatar.jpg'
    link_to avatar(avatar_path, options), profile_admin_user_path(user), remote: true
  end

  def editable_text_column(resource, attr)
    val = resource.send(attr)
    val = '' if val.blank?
    out = []
    out << content_tag(:div, val,
                       id: "editable_text_column_#{attr}_#{resource.id}",
                       class: 'editable_text_column',
                       ondblclick: 'quickEditable.editable_text_column_do(this)')
    out << content_tag(:input, nil,
                       class: 'editable_text_column admin-editable',
                       id: "editable_text_column_#{attr}_#{resource.id}",
                       style: 'display:none;',
                       data: { path: resource_path(resource),
                               'resource-class': resource.class.name.downcase.gsub(/::/, '_'),
                               attr: attr })
    safe_join(out)
  end

  def topic_excellent_link(topic)
    if topic.excellent?
      link_to I18n.t('unexcellent'), unexcellent_admin_topic_path(topic), method: :post
    else
      link_to I18n.t('excellent'), excellent_admin_topic_path(topic), method: :post
    end
  end

  def comment_excellent_link(comment)
    if comment.excellent?
      link_to I18n.t('unexcellent'), unexcellent_admin_comment_path(comment), method: :post
    else
      link_to I18n.t('excellent'), excellent_admin_comment_path(comment), method: :post
    end
  end
end
