class Manage::AppraisesController < Manage::BaseController

  def index
    klass = nil
    if params[:type].present?
      case params[:type]
      when 'comment', 'rating'
        klass = params[:type].camelize.constantize
      else
        klass = nil
      end
    end
    if klass
      if params[:approved].present?
        @resources = paginate klass.where(approved: params[:approved])
      else
        @resources = paginate klass.all
      end
      @partial = params[:type] + "_table"
      @type = klass.name
    end
  end

end
