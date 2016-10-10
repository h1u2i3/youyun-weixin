class Weixin::TagsController < Weixin::BaseController

  def index
    unless params[:id]
      return render text: 'Forbidden', status: 403
    end
    @title = "按服务浏览"
    render 'weixin/page/search',
            locals: {
                doctors: Doctor.includes(:hospital, :skills).joins(:goods).where(id: Good.select(:doctor_id).joins(:tags).where('tags.id = ?', params[:id])).uniq ,
                title: Tag.find(params[:id]).name }
  end

end
