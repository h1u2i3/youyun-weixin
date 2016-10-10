# == Schema Information
#
# Table name: cases
#
#  id             :integer          not null, primary key
#  symptom        :string
#  check          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :integer
#

class Case < ActiveRecord::Base
  belongs_to :appointment
  has_many :attach_images

  validates_presence_of :symptom
end
