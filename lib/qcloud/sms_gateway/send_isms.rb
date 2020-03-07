# 发送国际短信的接口
module Qcloud
  module SmsGateway
    SMS_URI = '/v5/tlssmssvr/sendisms'.freeze

    class SendIsms
      def initialize
        @app_id = app_config[:appid]
        @app_key = app_config[:appkey]
        @current_time = Time.now.to_i
        @random = Random.new.rand(100000..999999)
      end

      # mobile 如果是大陆，可以不传区号，如果是国外或香港澳门，需要ext字段
      def send(mobile, msg, options = {})
        ext = options[:ext].presence || '86'
        str_mobile = "+#{ext}#{mobile}" # 带区号带手机号

        # 写入日志信息
        last_id = write_log(mobile, ext, msg)
        params = {
          ext: last_id,
          extend: '',
          msg: msg,
          sig: calculate_sig(str_mobile),
          tel: str_mobile,
          time: @current_time,
          type: options[:sms_type].presence || 0 # 非营销类，如果是营销类，这里传1
        }
        # 开始发送短信
        result = Qcloud::SmsGateway::Remote.post(set_url, params)
        update_log(last_id, result)
      end

      def self.send(mobile, msg, options = {})
        new.send(mobile, msg, options)
      end

      private

      def calculate_sig(mobile)
        hash_string = "appkey=#{@app_key}&random=#{@random}&time=#{@current_time}&tel=#{mobile}"
        Digest::SHA256.hexdigest(hash_string)
      end

      def set_url
        "#{SMS_URI}?sdkappid=#{@app_id}&random=#{@random}"
      end

      def write_log(mobile, ext, content)
        SmsLog.create!(mobile: mobile,
                       ext: ext,
                       content: content,
                       send_time: Time.zone.now,
                       status: 'sending').id
      end

      def update_log(log_id, params)
        sms = SmsLog.find(log_id)
        sid = params['sid'] || ''
        error_msg = params['errmsg'] || ''
        fee = params['fee'] || 0
        status = params['result'].zero? ? 'success' : 'failed'
        Rails.logger.info "log_id=#{log_id}----sms=#{sms}, sid=#{sid}, error_msg=#{error_msg}, fee=#{fee}"
        update_params = {
            sid: sid,
            error_msg: error_msg,
            fee: fee,
            status: status,
            arrival_time: Time.zone.now
        }
        sms.update!(update_params)
      end

      def app_config
        raise '需要配置sdkappid或appkey' if ENV['APPID'].blank? || ENV['APPKEY'].blank?
        {
            appid: ENV['APPID'],
            appkey: ENV['APPKEY']
        }
      end
    end
  end
end