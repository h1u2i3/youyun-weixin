class Manage::BaseController < ApplicationController
  layout 'manage'

  before_filter :need_admin_login!
  helper_method :current_admin

  def current_admin
    @current_admin ||= Admin.find_by!(id: session[:admin_id]) if session[:admin_id]
  end

  def paginate(resource)
    resource = resource.page(params[:page] || 1)
    if params[:per_page]
      resource = resource.per(params[:per_page])
    end
    return resource
  end

  private

  def need_admin_login!
    unless current_admin
      redirect_to manage_login_path
    end
  end

end
