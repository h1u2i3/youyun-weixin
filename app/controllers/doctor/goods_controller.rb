class Doctor::GoodsController < Doctor::BaseController

  def index
    @goods = current_doctor.goods
  end

  def new
    @good = current_doctor.goods.build
  end

  def create
    @good = Good.new(good_params)
    unless @good.save
      render 'error'
    end
    @goods = current_doctor.goods
  end

  def edit
    @good = current_doctor.goods.where(id: params[:id]).first
  end

  def update
    @good = current_doctor.goods.where(id: params[:id]).first
    unless @good.update(good_params)
      render 'error'
    end
    @goods = current_doctor.goods
  end

  def destroy
    @good = current_doctor.goods.where(id: params[:id]).first
    if @good.destroy
      @goods = current_doctor.goods
    end
  end

  def cancel
  end

  private

    def good_params
      params.require(:good).permit(:doctor_id, :name, :description, :price, :published, tag_ids: [])
    end
end
