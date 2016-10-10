# == Schema Information
#
# Table name: hospitals
#
#  id            :integer          not null, primary key
#  name          :string
#  doctors_count :integer          default(0)
#  created_at    :datetime
#  updated_at    :datetime
#

class Hospital < ActiveRecord::Base
  has_many :doctors
end
