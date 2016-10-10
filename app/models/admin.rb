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

class Admin < ActiveRecord::Base
  has_secure_password
end
