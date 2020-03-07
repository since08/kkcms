# required
# 测试环境时不初始WxPay
unless Rails.env.test?
  WxPay.appid = ENV['WX_APP_ID']
  WxPay.key = ENV['WX_APP_KEY']
  WxPay.mch_id = ENV['WX_MCH_ID']
  WxPay.apiclient_key  = File.read(ENV['WX_APICLIENT_KEY'])
  WxPay.apiclient_cert = File.read(ENV['WX_APICLIENT_CERT'])

# if you want to use `generate_authorize_req` and `authenticate`
# WxPay.appsecret = ENV['APP_SECRET']

# optional - configurations for RestClient timeout, etc.
  WxPay.extra_rest_client_options = { timeout: 30, open_timeout: 30 }
end

