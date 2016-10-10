class Weixin::ProfilesController < Weixin::BaseController

	def show
    @prepay_apms = current_user.appointments.prepay
		@ready_apms = current_user.appointments.ready
		@comment_apms = current_user.appointments.wait_for_rating.concat(current_user.appointments.wait_for_comment).uniq
	end

end
