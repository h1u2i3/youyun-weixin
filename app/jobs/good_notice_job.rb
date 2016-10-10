class GoodNoticeJob < ActiveJob::Base
  queue_as :default

  def perform(status, doctor_id)
    doctor = Doctor.find(doctor_id)
    ActionCable.server.broadcast "notices:#{doctor_id}:notify",
      status: status,
      doctor: doctor_id,
      view: ActionView::Base.new(Rails.configuration.paths['app/views']).render(
              partial: 'weixin/doctors/good_detail',
              formats: [:html],
              handlers: [:slim],
              locals: { doctor:  doctor }
            )
  end

end
