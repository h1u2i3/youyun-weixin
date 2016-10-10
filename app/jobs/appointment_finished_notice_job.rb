class AppointmentFinishedNoticeJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    ActionCable.server.broadcast "appointments:#{id.to_i}:notify",
      status: true
  end

end
