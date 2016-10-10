class Doctor::ClinicsController < Doctor::BaseController

  def index
    # get authorit from Weixin
    @result = WECHAT_DOCTOR_API.jsapi_ticket.signature(doctor_clinics_url)
  end

  def create
    @appointment = Appointment.find(params[:id])
    if !@appointment.finished?
      @appointment.finish_clinic
      # @appointment.toggle!(:finished)
      # AppointmentFinishedNoticeJob.perform_later(@appointment.id)
      # RatingNotifyJob.wait(1.day).perform_later(@appointment.id)
      # CommentNotifyJob.wait(8.days).perform_later(@appointment.id)
      # RatingNotifyJob.set(wait: 1.minute).perform_later(@appointment.id)
      # CommentNotifyJob.set(wait: 8.minutes).perform_later(@appointment.id)
    end
    if params[:type] && params[:type] == 'manual'
      return render 'manual_create'
    end
  end

  def manual
    unless params[:unique_number].blank?
      @appointments = current_doctor.appointments.where(appoint_unique_number: params[:unique_number]).ready
    else
      @appointments = current_doctor.appointments.today.ready
    end
  end

  def identify
    # get the encrypted message and verify the message
    # use the encrypted message method for rails 4
    message = params[:message]
    begin
      apm_unique_number = Rails.application.message_verifier(current_doctor.openid).verify(message)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      apm_unique_number = nil
    end
    @appointment = nil
    if apm_unique_number
      @appointment = Appointment.find_by(appoint_unique_number: apm_unique_number)
    end
  end

end

__END__

wx.config({
    debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
    appId: '', // 必填，公众号的唯一标识
    timestamp: , // 必填，生成签名的时间戳
    nonceStr: '', // 必填，生成签名的随机串
    signature: '',// 必填，签名，见附录1
    jsApiList: [] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
});
