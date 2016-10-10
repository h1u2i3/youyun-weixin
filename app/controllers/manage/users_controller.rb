class Manage::UsersController < Manage::BaseController

  def index
    @users = paginate(User.all)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  def search
    keyword = params[:keyword]
    if keyword.empty?
      @users = paginate(User.all)
    else
      @users = paginate(User.where("name like ? or openid like ?", "%#{keyword}%", "%#{keyword}%"))
    end
  end

  def detail
  end

  def detail_search
    openid = params[:openid]
    @user = User.find_by(openid: openid)
    @appointments = @comments = nil
    if @user
      @appointments = paginate(@user.appointments)
      @comments = paginate(@user.comments)
    end
  end

end



__END__

create_table "comments", force: :cascade do |t|
  t.integer  "appointment_id"
  t.string   "progress"
  t.string   "result"
  t.datetime "created_at",                     null: false
  t.datetime "updated_at",                     null: false
  t.integer  "user_id"
  t.integer  "doctor_id"
  t.boolean  "checked",        default: false
  t.boolean  "approved",       default: true
  t.integer  "progress_score"
  t.integer  "result_score"
end
