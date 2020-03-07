# 发送邮件短信验证码任务
class SendEmailSmsJob < ApplicationJob
  queue_as :send_email_sms_jobs

  def perform(sms_type, email, content, title)
    logger = Resque.logger
    logger.info "[SendEmailSmsJob] Send #{sms_type} SMS to #{email}: #{content}]"
    UserMailer.welcome(email, content, title).deliver_now
  end
end
