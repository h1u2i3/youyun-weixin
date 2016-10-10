# == Schema Information
#
# Table name: incomes
#
#  id             :integer          not null, primary key
#  doctor_id      :integer
#  number         :float
#  user_openid    :string
#  appointment_no :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class IncomeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
