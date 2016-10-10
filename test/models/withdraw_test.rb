# == Schema Information
#
# Table name: withdraws
#
#  id         :integer          not null, primary key
#  doctor_id  :integer
#  number     :float
#  operator   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class WithdrawTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
