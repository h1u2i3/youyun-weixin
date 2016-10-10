class Weixin::DoctorsController < Weixin::BaseController
  before_action :set_the_session, only: :show

  def index
    # session[:back_links] = []
    threads = []
    threads << Thread.new {
      @skills = Skill.all
    }
    threads << Thread.new {
      @departments = Department.all
    }
    threads << Thread.new {
      @tags = Tag.all
    }
    threads.each { |t| t.join }
  end

  def show
    @doctor = Doctor.includes(:calenders, :skills, :goods, :ratings, :comments).find(params[:id])
    @calenders = @doctor.calenders.reject { |e| e.calender_end_time < Time.current }.group_by {|calender| calender.calender_day}
  end

  def search
    if params[:name]
      @doctors = Doctor.where("name like ?", "%#{params[:name]}%")
      @title = '搜索结果'
      render 'weixin/page/search', locals: { doctors: @doctors, title: "医生列表" }
    else
      redirect_to weixin_doctors_path
    end
  end

  private

  def set_the_session
    cookies.signed[:doctor_detail] = request.fullpath.split('/').last
  end

end

__END__

SELECT *, (SELECT name FROM hospitals WHERE id = doctors.id)  FROM doctors WHERE id = 13
