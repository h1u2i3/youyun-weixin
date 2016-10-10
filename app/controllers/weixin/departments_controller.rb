class Weixin::DepartmentsController < Weixin::BaseController

  def index
    unless params[:id]
      return render text: 'Forbidden', status: 403
    end
    @title = "按科室浏览"
    render 'weixin/page/search',
           locals: {
              doctors: Doctor.includes(:hospital, :skills).joins(:departments).where("departments.id = ?", params[:id]), 
              title:  Department.find(params[:id]).name }
  end

end
