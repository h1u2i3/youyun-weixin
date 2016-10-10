class AppointmentsChannel < ApplicationCable::Channel

  def follow(data)
    stop_all_streams
    stream_from "appointments:#{data['appointment_id'].to_i}:notify"
  end

  def unfollow
    stop_all_streams
  end

end
