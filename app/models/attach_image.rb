# == Schema Information
#
# Table name: attach_images
#
#  id         :integer          not null, primary key
#  case_id    :integer
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AttachImage < ActiveRecord::Base
  belongs_to :case
end
