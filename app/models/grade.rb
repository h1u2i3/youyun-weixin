# == Schema Information
#
# Table name: grades
#
#  id            :integer          not null, primary key
#  name          :string
#  doctors_count :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Grade < ActiveRecord::Base
  has_many :doctors, counter_cache: true
end
