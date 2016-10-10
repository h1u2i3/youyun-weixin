class Manage::AppointmentsController < Manage::BaseController

  before_action :find_the_appointment, only: [:show, :edit, :update, :refund]

  def index
    page = params[:page].present? ? params[:page] : 1
    if params[:status].present?
      case params[:status]
      when 'prepay'
        @appointments = Appointment.prepay.order('calender_datetime DESC, id').page(page)
      when 'canceled'
        @appointments = Appointment.canceled.order('calender_datetime DESC, id').page(page)
      when 'payed'
        @appointments = Appointment.ready.order('calender_datetime DESC, id').page(page)
      when 'finished'
        @appointments = Appointment.finished.order('calender_datetime DESC, id').page(page)
      when 'commenting'
        @appointments = Appointment.commenting.order('calender_datetime DESC, id').page(page)
      when 'refunding'
        @appointments = Appointment.refunding.order('calender_datetime DESC, id').page(page)
      when 'refunded'
        @appointments = Appointment.refunded.order('calender_datetime DESC, id').page(page)
      end
    elsif params[:key].present?
      @appointments = Appointment.where(appoint_unique_number: params[:key]).page(page)
    end
  end

  def show
  end

  def edit
    @doctor = @appointment.doctor
  end

  def update
    unless @appointment.endorse(params[:appointment][:calender_id])
      return render 'error'
    end
    @appointments = [ @appointment ]
  end

  def destroy
  end

  def refund
    if @appointment.refunding
      @appointment.refund
    else
      @appointment.prepare_for_refund
    end
    @appointments = [ @appointment ]
  end

  def notify
  end

  private

    def find_the_appointment
      @appointment = Appointment.unscoped.find(params[:id])
    end

end
