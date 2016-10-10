class AutoFinishAppointmentJob < ActiveJob::Base
  queue_as :default

  def perform
    appointments = Appointment.ready.where("calender_datetime < ?", 12.hours.ago)
    if appointments.any?
      appointments.each do |appointment|
        appointment.finish_clinic
      end
    end
  end
end
