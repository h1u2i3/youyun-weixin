# == Schema Information
#
# Table name: departments
#
#  id            :integer          not null, primary key
#  name          :string
#  doctors_count :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Department < ActiveRecord::Base
  has_and_belongs_to_many :doctors, counter_cache: true
end
