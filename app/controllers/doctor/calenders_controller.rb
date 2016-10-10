class Doctor::CalendersController < Doctor::BaseController

  before_action :batch_params_typecast, only: :create_batch

  def index
    @calenders = current_doctor.calenders.available_calender.group_by { |d| d.calender_day}
  end

  def edit
    @calender = current_doctor.calenders.where(id: params[:id]).first
  end

  def new
    @calender = current_doctor.calenders.build
  end

  def create
    @calender = Calender.new(calender_params)
    @place =  Place.new(address: params[:address], doctor_id: current_doctor.id) if params[:address].present?
    begin
      Calender.transaction do
        @place.save! if @place
        @calender.calender_place = @place.address if @place
        @calender.save!
      end
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      return render 'error'
    end
    @calenders = current_doctor.calenders.available_calender.group_by { |d| d.calender_day}
  end

  def destroy
    @calender = current_doctor.calenders.where(id: params[:id]).first
    if @calender
      @calender.delete
      @calenders = current_doctor.calenders.available_calender.group_by { |d| d.calender_day}
      return render 'destroy'
    end
  end

  def update
    @calender = current_doctor.calenders.where(id: params[:id]).first
    @place =  Place.new(address: params[:address], doctor_id: current_doctor.id) if params[:address].present?
    begin
      Calender.transaction do
        @place.save! if @place
        @calender.update!(calender_params)
        @calender.update_attribute(:calender_place, @place.address) if @place
      end
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      return render 'error'
    end
    @calenders = current_doctor.calenders.available_calender.group_by { |d| d.calender_day}
  end

  def single_day
    @calenders = Calender.where(calender_day: params[:day])
  end

  def cancel
  end

  def new_batch
    @batch = BatchCalender.new
  end

  def create_batch
    @batch = BatchCalender.new(@batch_params)
    if @batch.valid?
      @place =  Place.new(address: params[:new_address], doctor_id: current_doctor.id) if batch_params[:new_address].present?

      begin
        Calender.transaction do
          @place.save! if @place
          batch_days.each do |day|
            Calender.create!(
              calender_place: @place ? @place.address : @batch_params[:address],
              calender_start_time: Time.new(day.year.to_i, day.month.to_i, day.day.to_i, @batch_params[:start_time].hour.to_i, @batch_params[:start_time].min.to_i),
              calender_end_time: Time.new(day.year.to_i, day.month.to_i, day.day.to_i, @batch_params[:end_time].hour.to_i, @batch_params[:end_time].min.to_i),
              calender_day: day.strftime("%Y-%m-%d"),
              calender_capacity: @batch_params[:capcity],
              doctor_id: current_doctor.id,
              published: true
            )
          end
        end
      rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      end
      @calenders = current_doctor.calenders.available_calender.group_by { |d| d.calender_day}
    else
      return render 'batch_error'
    end
  end

  private

    def calender_params
      params.require(:calender).permit(:doctor_id, :calender_day, :calender_place, :calender_capacity, :calender_start_time, :calender_end_time)
    end

    def batch_params
      params.require(:batch_calender).permit(:month, :address, :start_time, :end_time, :add_address, :capcity, weekday: [])
    end

    def batch_params_typecast
      @batch_params = {}
      @batch_params[:start_time] = Time.parse("#{batch_params['start_time(1i)']}-#{batch_params['start_time(2i)']}-#{batch_params['start_time(3i)']} #{batch_params['start_time(4i)']}:#{batch_params['start_time(5i)']}")
      @batch_params[:end_time] = Time.parse("#{batch_params['end_time(1i)']}-#{batch_params['end_time(2i)']}-#{batch_params['end_time(3i)']} #{batch_params['end_time(4i)']}:#{batch_params['end_time(5i)']}")
      @batch_params[:address] = batch_params[:address]
      @batch_params[:month] = batch_params[:month]
      @batch_params[:weekday] = batch_params[:weekday]
      @batch_params[:capcity] = batch_params[:capcity]
    end

    def batch_days
      (Date.new(Date.today.year.to_i, @batch_params[:month].to_i, 1)..Date.new(Date.today.year.to_i, @batch_params[:month].to_i, -1)).to_a.keep_if { |day| @batch_params[:weekday].include? day.wday.to_s }
    end

end

# == Schema Information
#
# Table name: calenders
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  doctor_id           :integer
#  calender_day        :string
#  calender_place      :string
#  calender_capacity   :integer
#  calender_start_time :datetime
#  calender_end_time   :datetime
#  published           :boolean          default(FALSE)
#  calender_deal       :integer          default(0)
#  deal_appointment    :integer          default(0)
