# == Schema Information
#
# Table name: comments
#
#  id             :integer          not null, primary key
#  appointment_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  doctor_id      :integer
#  checked        :boolean          default(FALSE)
#  approved       :boolean          default(TRUE)
#  content        :text
#

class Comment < ActiveRecord::Base
  belongs_to :appointment
  belongs_to :doctor, counter_cache: true, touch: true
  belongs_to :user, counter_cache: true

  default_scope -> { where(checked: true) }

  validates_length_of :content, minimum: 5
end
