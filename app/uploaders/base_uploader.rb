class BaseUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick
  process resize_to_limit: [1080, nil]

  def store_dir
    "uploads/#{model.class.to_s.underscore}"
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  def crop
    return if model.crop_x.blank?

    manipulate! do |img|
      x = model.crop_x.to_i
      y = model.crop_y.to_i
      w = model.crop_w.to_i
      h = model.crop_h.to_i
      img.crop([[w, h].join('x'), [x, y].join('+')].join('+'))
    end
  end

  def filename
    return if original_filename.nil? # 没有原始图片时，也就是非上传的情况

    return model[mounted_as] unless version_name.nil? # 当存在version时，使用主图的path

    @md5_name ||= Digest::MD5.hexdigest(current_path)
    "#{@md5_name}.#{file.extension.downcase}"
  end

  # 在 UpYun 配置图片缩略图
  # http://docs.upyun.com/guide/#_12
  # 固定宽度,高度自适应
  # xs - 100
  # sm - 200
  # md - 500
  # lg - 1080

  ALLOW_CDN_VERSIONS = %w[xs sm md lg].freeze
  def url(version_name = nil)
    return super unless version_name.to_s.in?(ALLOW_CDN_VERSIONS)

    @url ||= super({})
    return if @url.nil?

    [@url, version_name].join('!')
  end
end
