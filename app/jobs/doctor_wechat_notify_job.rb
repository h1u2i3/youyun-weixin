class DoctorWechatNotifyJob < ActiveJob::Base

  queue_as :default

  def perform(appointment_id)
    appointment = Appointment.find(appointment_id)

    calender = appointment.calender
    doctor = appointment.doctor
    good = appointment.good

    message = {
      title: "购买服务通知",
      description: "尊敬的#{doctor.name}主任，您好，有用户预定了#{calender.calender_day_in_time_display}#{good.name}服务，症状描述内容：#{appointment.case.symptom}。"
    }

    WECHAT_DOCTOR_API.custom_message_send Wechat::Message.to(doctor.openid).news([message])
  end
end
