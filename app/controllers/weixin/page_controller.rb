class Weixin::PageController < Weixin::BaseController

  def index
    @doctors = Doctor.includes(:hospital, :skills).published.order('doctors.name ASC')
  end

  def frq
  end

end
