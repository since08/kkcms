require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# load .env
Dotenv::Railtie.load

module Kkcms
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.i18n.default_locale = 'zh-CN'
    config.time_zone = 'Beijing'
    config.active_job.queue_adapter = :resque

    # auto_load
    config.autoload_paths += [
        Rails.root.join('lib'),
        Rails.root.join('app/models/merchant'),
    ]

    # eager_load
    config.eager_load_paths += [
        Rails.root.join('lib/qcloud'),
        Rails.root.join('lib/geo/**')
    ]

    # sanitize 自定义白名单
    config.action_view.sanitized_allowed_attributes = Set.new(%w(href src width height alt cite datetime title class name xml:lang abbr style))
  end
end
