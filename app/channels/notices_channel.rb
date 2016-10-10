class NoticesChannel < ApplicationCable::Channel

  def follow(data)
    stop_all_streams
    stream_from "notices:#{data['doctor_id'].to_i}:notify"
  end

  def unfollow
    stop_all_streams
  end

end
