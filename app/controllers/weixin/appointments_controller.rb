class Weixin::AppointmentsController < Weixin::BaseController

  skip_before_filter :verify_authenticity_token, :authenticate_user_openid!, only: :notify
  before_action :find_appointment, only: [:destroy, :pay, :status, :cancel, :detail]

  def index
    unless params[:status]
      return render text: 'Forbidden', status: 403
    end
    case params[:status]
    when 'finished'
      @title = "已完成订单"
      @appointments = current_user.appointments.finished
    when 'canceled'
      @title = "已取消订单"
      @appointments = Appointment.canceled.where(user_id: current_user.id)
    when 'refunded'
      @title = "已退款订单"
      @appointments = Appointment.refunded.where(user_id: current_user.id)
    end
  end

  def new
    unless @appointment
      unless params[:doctor_id] && params[:good_id] && params[:day]
        return render text: 'Forbidden', status: 403
      end
      @doctor = Doctor.find(params[:doctor_id])
      @good = Good.find(params[:good_id])
      day = params[:day].split('-')
      @day = "#{day[0]}年#{day[1]}月#{day[2]}日"
      @calenders = @doctor.calenders.where(calender_day: params[:day]).sellable_calender
      unless @calenders.any?
        retrun render 'error'
      end
      # @appointment = Appointment.new(doctor_id: params[:doctor_id], good_id: params[:good_id])
      if Rails.env == 'development'
        @appointment = Appointment.new(
          user_id: (1..100).to_a.sample,
          doctor_id: params[:doctor_id],
          good_id: @good.id
          )
      else
        @appointment = Appointment.new(
          user_id: current_user.id,
          doctor_id: params[:doctor_id],
          good_id: @good.id
          )
      end
      @appointment.build_case
    end
    @last_appointment = current_user.last_appointment
  end

  def cancel
    if @appointment.can_cancel?
      @appointment.toggle!(:canceled)
    end
  end

  def create
    @appointment = Appointment.new(appointment_params)
    return render 'error' unless @appointment.calender.availabe?

    if @appointment.save
      # back job for cancel appointment in 20 minutes
      if Rails.env == 'development'
        @appointment.perform_payed
      end
      AppointmentCancelJob.set(wait: 20.minutes).perform_later(@appointment.id)
    else
      render 'error'
    end
  end

  def detail
  end

  def show
    @appointment = Appointment.unscoped.find(params[:id])
  end

  def status
  end

  def notify
    result = Hash.from_xml(request.body.read)["xml"]
    if WxPay::Sign.verify?(result)
      appointment = Appointment.unscoped.find_by(appoint_unique_number: result["out_trade_no"])
      appointment.perform_payed
      AppointmentSuccessNotifyJob.set(wait: 1.minute).perform_later(appointment.user.openid, appointment.id)
      render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
    else
      render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
  end

  def pay
    pay_params = {
      body: @appointment.good.name,
      out_trade_no: @appointment.appoint_unique_number.to_s,
      total_fee: @appointment.good.price_in_cents,
      spbill_create_ip: request.remote_ip,
      notify_url: notify_weixin_appointments_url,
      trade_type: 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
      openid: current_user.openid # required when trade_type is `JSAPI`
    }
    @pay_pre_response = WxPay::Service.invoke_unifiedorder pay_params
    @params = {
      "appId": @pay_pre_response["appid"],
      "timeStamp": Time.now.to_i.to_s,
      "nonceStr": @pay_pre_response["nonce_str"],
      "package": "prepay_id=#{@pay_pre_response["prepay_id"]}",
      "signType": "MD5"
    }
    @params = {
      "paySign": WxPay::Sign.generate(@params)
    }.merge(@params)
  end

  private

  def bad_request!
    return render text: 'Forbidden', status: 403
  end

  def appointment_params
    params.require(:appointment).permit(:doctor_id, :user_id, :good_id, :cellphone, :calender_id, case_attributes: :symptom )
  end

  def find_appointment
    @appointment = Appointment.find(params[:id])
  end

end
