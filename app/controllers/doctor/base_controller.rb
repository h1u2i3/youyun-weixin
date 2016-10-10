class Doctor::BaseController < ApplicationController

  layout 'doctor'

  before_filter :authenticate_doctor_openid!, :validate_the_doctor
  helper_method :current_doctor

  def current_doctor
    @current_doctor ||= Doctor.find_by(openid: session[:weixin_doctor_openid]) if session[:weixin_doctor_openid]
    @current_doctor
  end

  def authenticate_doctor_openid!

    if Rails.env == 'development'
      session[:weixin_doctor_openid] ||= (100..105).map { |i| User.find(i).openid }.sample
    else

      # debugger

      unless /MicroMessenger/.match(request.user_agent)
        return render text: 'Forbidden', status: 403
      end

      # initailize the back stack
      session[:back_links] = []

      if session[:weixin_doctor_openid].blank?
        code = params[:code]

        if code.nil?
          return request_for_code! request.url
        else
          begin
            url    = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{APP_CONFIG["wechat_doctor"]["appid"]}&secret=#{APP_CONFIG["wechat_doctor"]["secret"]}&code=#{code}&grant_type=authorization_code"
            session[:weixin_doctor_openid] = JSON.parse(URI.parse(url).read)["openid"]
            # cookies.signed[:weixin_user_openid] = session[:weixin_doctor_openid]
          rescue Exception => e
          end
        end

      end
    end

  end

  def validate_the_doctor
    unless current_doctor
      if predoctor = Predoctor.find_by(openid: session[:weixin_doctor_openid])
        return render 'doctor/page/predoctor_in_progress'
      else
        return render 'doctor/page/predoctor'
      end
    end
  end

  def request_for_code! url
    redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{APP_CONFIG["wechat_doctor"]["appid"]}&redirect_uri=#{Rack::Utils.escape(url)}&response_type=code&scope=snsapi_base&state=#{Rack::Utils.escape(url)}#wechat_redirect"
  end

end
