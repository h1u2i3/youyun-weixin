class Weixin::BaseController < ApplicationController
  layout 'weixin'

  before_filter :authenticate_user_openid!
  helper_method :current_user

  def current_user
    return @current_user if @current_user
    if session[:weixin_user_openid]
      user = User.find_by(openid: session[:weixin_user_openid])
      unless user
        user = User.create(openid: session[:weixin_user_openid], nickname: WECHAT_USER_API.user(session[:weixin_user_openid])["nickname"])
      end
      @current_user = user
    else
      @current_user = nil
    end
    @current_user
  end

  def authenticate_user_openid!

    if Rails.env == 'development'
      session[:weixin_user_openid] ||= (100..104).map { |i| User.find(i).openid }.sample
      cookies.signed[:weixin_user_openid] = session[:weixin_user_openid]
    else
      unless /MicroMessenger/.match(request.user_agent)
        return render text: 'Forbidden', status: 403
      end

      # debugger

      # initailize the back stack
      session[:back_links] = []

      if session[:weixin_user_openid].blank?
        code = params[:code]

        if code.nil?
          return request_for_code! request.url
        else
          begin
            url    = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{APP_CONFIG["wechat_user"]["appid"]}&secret=#{APP_CONFIG["wechat_user"]["secret"]}&code=#{code}&grant_type=authorization_code"
            session[:weixin_user_openid] = JSON.parse(URI.parse(url).read)["openid"]
            cookies.signed[:weixin_user_openid] = session[:weixin_user_openid]
          rescue Exception => e
          end
        end
      end
    end

  end

  def request_for_code! url
    redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{APP_CONFIG["wechat_user"]["appid"]}&redirect_uri=#{Rack::Utils.escape(url)}&response_type=code&scope=snsapi_base&state=#{Rack::Utils.escape(url)}#wechat_redirect"
  end

end
