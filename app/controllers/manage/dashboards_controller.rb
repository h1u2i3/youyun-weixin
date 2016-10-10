class Manage::DashboardsController < Manage::BaseController

  def show
    @user_count = User.all.size
    @appointment_count = Appointment.all.size
    @doctir_count = Doctor.all.size
  end

end
