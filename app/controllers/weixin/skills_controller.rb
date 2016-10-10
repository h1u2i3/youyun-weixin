class Weixin::SkillsController < Weixin::BaseController

  def index
    unless params[:id]
      return render text: 'Forbidden', status: 403
    end
    @title = "按擅长浏览"
    render 'weixin/page/search',
           locals: {
             doctors: Doctor.includes(:hospital, :skills).joins(:skills).where("skills.id = ?", params[:id]), 
             title: Skill.find(params[:id]).name }
  end

end
