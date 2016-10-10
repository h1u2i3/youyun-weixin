class AppointmentNoticeJob < ActiveJob::Base
  queue_as :default

  def perform(status, calender_day, id)
    appointment = Appointment.find(id)
    calenders = Calender.where(calender_day: calender_day).group_by { |calender| calender.calender_day }
    ActionCable.server.broadcast "notices:#{appointment.doctor.id.to_i}:notify",
      status: status,
      day: calender_day,
      view: ActionView::Base.new(Rails.configuration.paths['app/views']).render(
              partial: 'weixin/doctors/calender_detail',
              formats: [:html],
              handlers: [:slim],
              locals: { date:  Date.new( *(calender_day.split('-').map(&:to_i)) ), calenders: calenders }
            )
  end

end
