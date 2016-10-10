class Weixin::RatingsController < Weixin::BaseController
  layout 'comment'

  def index
    if index_params.blank?
      @ratings = Rating.where(user_id: current_user.id)
    else
      @ratings = Rating.where(index_params)
    end
  end

  def new
    @appointment = Appointment.find params[:appointment_id]
    if @appointment.rating
      redirect_to weixin_appointment_path @appointment
    else
      @rating = @appointment.build_rating(doctor_id: @appointment.doctor.id, user_id: current_user.id)
    end
  end

  def create
    @appointment = Appointment.find params[:appointment_id]
    unless @appointment.rating
      @rating = Rating.new(rating_params)
      unless @rating.save
        render 'error'
      end
    end
  end

  def thank
    @appointment = Appointment.find params[:appointment_id]
    if !@appointment.rating?
      redirect_to weixin_profile_path
    end
  end

  private

  def rating_params
    params.permit(:user_id, :doctor_id, :appointment_id, :attitude, :statisfication, :professional)
  end

  def index_params
    params.permit(:doctor_id)
  end
end
