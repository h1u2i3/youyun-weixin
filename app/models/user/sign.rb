class Admin::Sign
  include ActiveModel::Model
  # include ActiveModel::Conversion
  # include ActiveModel::Validations
  # include ActiveModel::Naming
  # extend ActiveModel::Callbacks

  attr_accessor :name, :password, :admin

  def valid?
    @admin = Admin.find_by(name: name)
    admin && admin.authenticate(password)
  end

end
