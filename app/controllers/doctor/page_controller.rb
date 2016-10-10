class Doctor::PageController < Doctor::BaseController

  skip_filter :validate_the_doctor, only: :sign

  def index
  end

  def sign
    unless Predoctor.find_by(openid: session[:weixin_doctor_openid])
      if Rails.env == 'development'
        Predoctor.create!(openid: session[:weixin_doctor_openid], name: ('a'..'z').to_a.sample(6).join)
      else
        Predoctor.create!(openid: session[:weixin_doctor_openid], name: WECHAT_DOCTOR_API.user(session[:weixin_doctor_openid])['nickname'])
      end
    end
    return render 'predoctor_in_progress'
  end

end
