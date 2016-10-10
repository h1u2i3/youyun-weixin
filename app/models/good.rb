# == Schema Information
#
# Table name: goods
#
#  id          :integer          not null, primary key
#  doctor_id   :integer
#  price       :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string
#  description :text
#  published   :boolean          default(FALSE)
#

class Good < ActiveRecord::Base
  belongs_to :doctor, ->{ unscope(where: :published) }
  has_many :appointments
  has_and_belongs_to_many :tags

  validates_presence_of :name, :price, :description

  default_scope -> { where(published: true )}

  after_create :anysc_notify
  after_update :anysc_notify
  after_destroy :anysc_notify

  def price_in_cents
    (self.price * 100).to_i
  end

  def anysc_notify
    GoodNoticeJob.perform_later('good', self.doctor_id)
  end

end
