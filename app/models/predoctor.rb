# == Schema Information
#
# Table name: predoctors
#
#  id         :integer          not null, primary key
#  name       :string
#  openid     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Predoctor < ActiveRecord::Base
end
