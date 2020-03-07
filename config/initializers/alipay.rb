$alipay = Alipay::Client.new(
  url: ENV['ALIPAY_API'],
  app_id: ENV['ALIPAY_APP_ID'],
  app_private_key: File.read(ENV['APP_PRIVATE_KEY']),
  alipay_public_key: File.read(ENV['ALIPAY_PUBLIC_KEY']),
  format: 'json',
  charset: 'UTF-8'
)