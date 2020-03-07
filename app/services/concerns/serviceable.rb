module Serviceable
  extend ActiveSupport::Concern

  module ClassMethods
    def call(*args)
      new(*args).call
    end
  end

  def error_result(msg)
    ApiResult.error_result(msg)
  end
end
