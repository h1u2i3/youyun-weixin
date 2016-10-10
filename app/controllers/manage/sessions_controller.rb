class Manage::SessionsController < ApplicationController
  layout 'login'

  before_filter :initialize_first_admin, if: :production_and_no_admin?

  def index
    if session[:admin_id] && Admin.find(session[:admin_id])
      redirect_to manage_root_path
    else
      @sign = Admin::Sign.new
    end
  end

  def create
    sign = Admin::Sign.new(sign_params)
    if sign.valid?
      session[:admin_id] = sign.admin.id
      redirect_to manage_root_path
    else
      redirect_to manage_login_path, flash: { notice: '用户名或密码错误！'}
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to manage_login_path
  end

  private

  def sign_params
    params.require(:admin_sign).permit(:name, :password)
  end

  def initialize_first_admin
    Admin.create( name: 'xiaohui', password: 'h1u2i3_gan', password_confirmation: 'h1u2i3_gan')
  end

  def production_and_no_admin?
    Rails.env == 'production' && Admin.all.empty?
  end

end
