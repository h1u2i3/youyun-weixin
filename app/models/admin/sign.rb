# == Schema Information
#
# Table name: admins
#
#  id              :integer          not null, primary key
#  name            :string
#  password_digest :string
#  level           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Admin::Sign < Admin
  # include ActiveModel::Model
  # include AciveModel::Conversion
  # include ActiveModel::Validations
  # include ActiveModel::Naming
  # extend ActiveModel::Callbacks

  attr_accessor :name, :password, :admin

  def valid?
    @admin = Admin.find_by(name: name)
    admin && admin.authenticate(password)
  end

end
