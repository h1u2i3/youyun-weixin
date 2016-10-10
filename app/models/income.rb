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

class Income < ActiveRecord::Base
  belongs_to :doctor, -> { unscope(where: :published) }
end
