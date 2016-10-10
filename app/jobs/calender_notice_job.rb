class CalenderNoticeJob < ActiveJob::Base
  queue_as :default

  def perform(status, doctor_id)
    initialize_actionview
    doctor = Doctor.find_by(id: doctor_id)
    calenders = doctor.calenders.available_calender.group_by {|calender| calender.calender_day}
    ActionCable.server.broadcast "notices:#{doctor_id}:notify",
      status: status,
      view: @action_view.render(
              partial: 'weixin/doctors/calender_notify',
              formats: [:html],
              handlers: [:slim],
              locals: { calenders: calenders }
            )
  end

  def initialize_actionview
    unless @action_view
      @action_view = ActionView::Base.new(Rails.configuration.paths["app/views"])
      @action_view.class_eval do
        include Rails.application.routes.url_helpers
        include WeixinCalenderHelper
        include WeixinHelper

        def protect_against_forgery?
          false
        end
      end
    end
  end

end
