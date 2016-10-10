class Manage::Baseinfo::BaseController < Manage::BaseController

  before_action :find_the_resource, except: :create

  class << self
    def get_resource
      @resource
    end

    def resource name
      @resource = name.to_s
    end
  end

  def create
    @resource = self.class.get_resource
    @instance_resource = @resource.capitalize.safe_constantize.create(name: params[:name])
    render 'manage/baseinfo/shared/doctor_info_create'
  end

  # def update
  #   @instance_resource.update(name: params[:name])
  # end

  def destroy
    @instance_resource.destroy
    render 'manage/baseinfo/shared/doctor_info_destroy'
  end

  private

  def find_the_resource
    @resource = self.class.get_resource
    @instance_resource = @resource.capitalize.safe_constantize.find(params[:id])
  end

end
