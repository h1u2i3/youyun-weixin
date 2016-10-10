class AppointmentRefundNotifyJob < ActiveJob::Base
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(openid, appointment_id)
    appointment = Appointment.unscoped.find(appointment_id)
    doctor = appointment.doctor
    appointment_url = weixin_appointment_url(host: "example.com", id: appointment.id)

    template = YAML.load(ERB.new(File.read("#{Rails.root}/config/messages/user_refund.yml.erb")).result(binding))

    WECHAT_USER_API.template_message_send Wechat::Message.to(openid).template(template)
  end
end
