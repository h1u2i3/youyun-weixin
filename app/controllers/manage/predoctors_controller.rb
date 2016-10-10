class Manage::PredoctorsController < Manage::BaseController

  def index
    @predoctors = Predoctor.all
  end

  def destroy
    @predoctor = Predoctor.find(params[:id])
    @predoctor.destroy
  end

end
