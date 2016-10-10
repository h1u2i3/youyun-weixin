
class AppointmentChangeNotifyJob < ActiveJob::Base
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(openid, appointment_id, old_time)
    appointment = Appointment.find(appointment_id)
    doctor = appointment.doctor
    appointment_url = weixin_appointment_url(host: "example.com", id: appointment.id)

    old_time = old_time
    new_time = appointment.calender_day + appointment.calender_time

    # notify user
    template = YAML.load(ERB.new(File.read("#{Rails.root}/config/messages/user_change.yml.erb")).result(binding))

    WECHAT_USER_API.template_message_send Wechat::Message.to(openid).template(template)

    # notify doctor


  end
end
