module Qcloud
  module SmsGateway
    SINGLE_SMS_URI = '/v5/tlssmssvr/sendsms'.freeze
    MULTIPLE_SMS_URI = '/v5/tlssmssvr/sendmultisms2'.freeze

    class SendSms
      attr_accessor :appid, :appkey, :uri

      def initialize(appid = app_config[:appid], appkey = app_config[:appkey])
        self.appid = appid
        self.appkey = appkey
        self.uri = SINGLE_SMS_URI # 默认是单发短信
      end

      # 可支持单发短信和群发短信功能
      # 如果是单发：mobile格式  '13866668888'， 群发mobile格式 '13866668888, 13566667777'
      # msg 短信内容，这个需要和申请的模板内容匹配
      # type: 0 -> 单发    1 -> 群发
      # options:
      #   code: 号码的区号，默认是 +86
      #   sms_type: 0 -> 普通短信   1-> 营销短信
      #   options: 可扩展字段,默认为空
      def send(mobile, msg, type = 0, options = {}) # rubocop:disable Metrics/MethodLength
        self.uri = MULTIPLE_SMS_URI unless type.zero?
        random = Random.new.rand(100000..999999)
        cur_time = Time.now.to_i
        sig = calculate_sig(appkey, random, cur_time, mobile)
        url = "#{uri}?sdkappid=#{appid}&random=#{random}"
        code = options[:code].presence || '86'
        sms_type = options[:sms_type].presence || 0
        # 写入日志信息
        last_id = write_log(mobile, msg)
        params = {
          tel: mobile_hash(mobile, type, code),
          type: sms_type,
          msg: msg,
          sig: sig,
          time: cur_time,
          extend: '',
          ext: last_id
        }
        # 开始发送短信
        result = Qcloud::SmsGateway::Remote.post(url, params)
        update_log(last_id, result)
      end

      def self.send(mobile, msg, type = 0, options = {})
        new.send(mobile, msg, type, options)
      end

      private

      def calculate_sig(appkey, random, curtime, mobile)
        mobiles = mobile.split(',')
        calculate_sig_temp_amd_mobile(appkey, random, curtime, mobiles)
      end

      def calculate_sig_temp_amd_mobile(appkey, random, curtime, mobiles)
        mobile = mobiles.join(',')
        hash_string = "appkey=#{appkey}&random=#{random}&time=#{curtime}&mobile=#{mobile}"
        Digest::SHA256.hexdigest(hash_string)
      end

      def mobile_hash(mobile, type, code)
        return { nationcode: code, mobile: mobile.strip } if type.zero?
        mobiles = mobile.split(',')
        mobiles.collect do |item|
          {
            nationcode: code,
            mobile: item.strip
          }
        end
      end

      def write_log(mobile, content)
        SmsLog.create!(mobile: mobile,
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