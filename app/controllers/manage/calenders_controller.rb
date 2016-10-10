class Manage::CalendersController < Manage::BaseController

  before_action :find_the_calender , only: [:edit, :update, :destroy, :publish]
  # after_action :anysc_notify_to_user, only: [:create, :update, :destroy, :publish]

  def index
    if params[:openid].present?
      @date = (params[:date].to_date if params[:date]) || Date.today
      @doctor = Doctor.find_by(openid: params[:openid])
      if @doctor
        @calenders = Calender.unscoped.where(doctor_id: @doctor.id).order(:calender_end_time)
                            .group_by { |calender| calender.calender_day }
      end
      render 'calender'
    end
  end

  def new
    date = params[:date]
    @doctor = Doctor.find_by(openid: params[:openid])
    @calender = Calender.new(calender_day: date, doctor_id: @doctor.id, calender_start_time: Time.new(date), calender_end_time: Time.new(date))
  end

  def create
    @place = Place.new(address: params[:address]) if params[:address].present?
    @calender = Calender.new(calender_params)
    if @place
      Doctor.find(calender_params[:doctor_id]).places << @place
      @calender.calender_place = @place.address
    end
    unless @calender.save
      render 'error'
    end
  end

  def edit
    @doctor = @calender.doctor
  end

  def update
    unless @calender.update(calender_params)
      render 'error'
    end
  end

  def destroy
    @calender.destroy
  end

  def publish
    @calender.toggle!(:published)
    render 'update'
  end

  private

  def calender_params
    params.require(:calender).permit(:calender_day, :calender_place, :start_time_text, :end_time_text, :calender_place, :calender_capacity, :doctor_id)
  end

  def find_the_calender
    @calender = Calender.unscoped.find(params[:id])
  end

  def anysc_notify_to_user
    @calender.anysc_notify
  end

end
