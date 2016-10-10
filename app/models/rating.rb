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

class Rating < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :doctor, counter_cache: true, touch: true
  belongs_to :appointment

  validates_presence_of  :attitude
  validates_presence_of  :professional
  validates_presence_of  :statisfication

  validate :check_the_rating

  private

    def check_the_rating
      if self.attitude == 0 || self.professional == 0 || self.statisfication == 0
        errors.add :base, "部分评分为空，请核对之后再提交。"
      end
    end

end
