# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  openid             :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  subscribe          :boolean
#  avatar             :string
#  appointments_count :integer          default(0)
#  comments_count     :integer          default(0)
#  ratings_count      :integer          default(0)
#  nickname           :string
#

class User < ActiveRecord::Base
  has_many :appointments
  has_many :comments

  scope :canceled_appointments, -> { appointments.where(canceled: true, refunded: false, refunding: false)}

  def last_appointment
    appointments.order(:created_at).first || nil
  end
end
