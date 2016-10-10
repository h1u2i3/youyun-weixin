# == Schema Information
#
# Table name: ratings
#
#  id             :integer          not null, primary key
#  attitude       :integer
#  professional   :integer
#  statisfication :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  doctor_id      :integer
#  appointment_id :integer
#  approved       :boolean          default(TRUE)
#

require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
