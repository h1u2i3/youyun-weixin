class AppointmentRatingNotifyJob < ActiveJob::Base
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(appointment_id)
    appointment = Appointment.find(appointment_id)
    unless appointment.rating?
      doctor = appointment.doctor
      appointment_url = weixin_appointment_url(host: "example.com", id: appointment.id)
      openid = appointment.user.openid

      template = YAML.load(ERB.new(File.read("#{Rails.root}/config/messages/user_rating.yml.erb")).result(binding))
      WECHAT_USER_API.template_message_send Wechat::Message.to(openid).template(template)
    end
  end
end
