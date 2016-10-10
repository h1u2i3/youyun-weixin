class WechatsController < ApplicationController
  skip_before_action :verify_authenticity_token

  wechat_responder appid: APP_CONFIG['wechat_user']['appid'],
                   secret: APP_CONFIG['wechat_user']['secret'],
                   token: APP_CONFIG['wechat_user']['token'],
                   access_token: APP_CONFIG['wechat_user']['access_token']

  on :fallback do |message|
    message.reply.transfer_customer_service
  end

end
