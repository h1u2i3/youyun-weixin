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

class Withdraw < ActiveRecord::Base
  belongs_to :doctor, ->{ unscope(where: :published) }
end
