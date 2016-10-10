class AppointmentCancelJob < ActiveJob::Base
  queue_as :default

  def perform(appointment_id)
    appointment = Appointment.unscoped.find(appointment_id)
    unless appointment.payed
      appointment.toggle!(:canceled)
    end
  end
end
