# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  address    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  doctor_id  :integer
#

class Place < ActiveRecord::Base
  belongs_to :dcotor
end
