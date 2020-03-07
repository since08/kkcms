source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'dotenv-rails'

# cache 相关
gem 'redis-rails', '~> 5.0', '>= 5.0.2'
gem 'second_level_cache', '~> 2.3.0'
gem 'resque', github: 'resque/resque'

# view 相关
gem 'haml'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'simditor'
gem 'remotipart'
gem 'fancybox2-rails'

# activeadmin 相关
gem 'activeadmin', '~> 1.3'
gem 'devise'
gem 'rails-i18n'

# 文件上传处理 相关
gem 'carrierwave', '~> 1.2', '>= 1.2.2'
gem 'carrierwave-upyun', '~> 0.2.2'
gem 'mini_magick', '~> 4.8'
gem 'pandoc-ruby'

gem 'geocoder'
gem 'best_in_place'
gem 'awesome_nested_set' # 多级类别

gem 'jmessage'

gem 'action-store'

# 微信支付
gem 'wx_pay'

# 支付宝相关
gem 'alipay', '~> 0.15.1'

gem 'whenever', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  gem 'rubocop', '~> 0.55.0', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'capistrano-git-with-submodules', '~> 2.0'
  gem "capistrano-resque", "~> 0.2.2", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
