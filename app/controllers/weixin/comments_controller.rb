class Weixin::CommentsController < Weixin::BaseController
  layout 'comment'

  def index
    if index_params.blank?
      @comments = Comment.where(user_id: current_user.id)
    else
      @comments = Comment.where(index_params)
    end
  end

  def new
    @appointment = Appointment.find params[:appointment_id]
    if @appointment.comment
      redirect_to weixin_appointment_path @appointment
    else
      @comment = @appointment.build_comment(doctor_id: @appointment.doctor.id, user_id: current_user.id)
    end
  end

  def create
    @appointment = Appointment.find params[:appointment_id]
    unless @appointment.comment
      @comment = Comment.new(comment_params)
      unless @comment.save
        render 'error'
      end
    end
  end

  def thank
  end

  private

  def comment_params
    params.permit(:user_id, :appointment_id, :doctor_id, :content)
  end

  def index_params
    params.permit(:doctor_id)
  end

end
