# == Schema Information
#
# Table name: doctors
#
#  id                 :integer          not null, primary key
#  name               :string
#  openid             :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  published          :boolean          default(FALSE)
#  hospital_id        :integer
#  grade_id           :integer
#  appointments_count :integer          default(0)
#  comments_count     :integer          default(0)
#  ratings_count      :integer          default(0)
#

class Doctor < ActiveRecord::Base
  has_many :goods
  has_many :appointments
  has_many :calenders
  has_many :ratings
  has_many :comments
  has_many :places
  has_many :incomes
  has_many :withdraws

  has_and_belongs_to_many :skills
  has_and_belongs_to_many :departments

  belongs_to :grade
  belongs_to :hospital, counter_cache: true

  validates_presence_of :name
  validates_presence_of :description

  scope :published, -> { where(published: true)}

  def available_calender
    self.calenders.available_calender
  end

end
