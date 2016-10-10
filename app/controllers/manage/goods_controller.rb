class Manage::GoodsController < Manage::BaseController

  before_action :find_the_good, only: [:edit, :update, :destroy, :publish]
  # after_action :anysc_notify_to_user, only: [:create, :update, :publish, :destroy]

  def index
    if params[:openid].present?
      @doctor = Doctor.unscoped.find_by(openid: params[:openid])
      if @doctor
        @goods = Good.unscoped { @doctor.goods.order(:id) }
      end
      render 'goods'
    end
  end

  def new
    @good = Good.new(doctor_id: params[:doctor_id])
  end

  def create
    @good = Good.new(good_params)
    unless @good.save
      render 'error'
    end
  end

  def edit
  end

  def update
    unless @good.update(good_params)
      render 'error'
    end
  end

  def destroy
    @good.destroy
  end

  def publish
    @good.toggle!(:published)
    render 'update'
  end


  private

  def find_the_good
    @good = Good.unscoped.find(params[:id])
  end

  def good_params
    params.require(:good).permit(:name, :price, :doctor_id, :description, tag_ids: [])
  end

  def anysc_notify_to_user
    @good.anysc_notify
  end

end
