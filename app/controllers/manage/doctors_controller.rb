class Manage::DoctorsController < Manage::BaseController

  before_action :find_the_doctor, only: [:edit, :update, :destroy, :publish]

  def index
    @doctors = paginate(Doctor.all.order(:name))
  end

  def new
  end

  def edit
  end

  def create
    @doctor = Doctor.new(doctor_params)
    unless @doctor.save
      render 'error'
    end
  end

  def update
    unless @doctor.update(doctor_params)
      render 'error'
    end
  end

  def destroy
    @doctor.destroy
  end

  def publish
    @doctor.toggle!(:published)
  end

  def search
    # debugger
    keyword = params[:keyword]
    if keyword.empty?
      @doctors = paginate(Doctor.all.order(:name))
    else
      # doctor = Doctor.find_by_sql ["SELECT * FROM doctors WHERE ( name like ? ) UNION SELECT * FROM doctors WHERE ( hospital_id = ( SELECT id FROM hospitals WHERE( name like ? )))", "%#{keyword}%", "%#{keyword}%"]
      @doctors = paginate(Doctor.where('name like ? or hospital_id in (?)', "%#{keyword}%", Hospital.where('name like ?',"%#{keyword}%").pluck(:id)))
    end
  end

  def detail_search
    # 输入医生的编号进行查找
    openid = params[:openid]
    @doctor = Doctor.find_by(openid: openid)
  end

  private

  def doctor_params
    params.require(:doctor).permit(:name, :openid, :grade_id, :description, :hospital_id, department_ids: [], skill_ids: [])
  end

  def find_the_doctor
    @doctor = Doctor.find(params[:id])
  end

end
