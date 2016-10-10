class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include YimeiError

  protect_from_forgery with: :exception

  before_filter :check_rack_mini_profiler

  rescue_from PathError, with: :render_404

  def check_rack_mini_profiler
    # for example - if current_user.admin?
    if Rails.env == 'staging'
      Rack::MiniProfiler.authorize_request
    end
  end

  # private

    def render_404
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end

end
