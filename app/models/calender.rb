# == Schema Information
#
# Table name: calenders
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  doctor_id           :integer
#  calender_day        :string
#  calender_place      :string
#  calender_capacity   :integer
#  calender_start_time :datetime
#  calender_end_time   :datetime
#  published           :boolean          default(FALSE)
#  calender_deal       :integer          default(0)
#  deal_appointment    :integer          default(0)
#

class Calender < ActiveRecord::Base
  has_many :appointments
  belongs_to :doctor

  validates_presence_of :calender_capacity
  validates_presence_of :calender_start_time
  validates_presence_of :calender_end_time
  validates_presence_of :calender_place

  validate :check_same_day_of_time, :check_the_time_order, if: ->(c) { c.calender_start_time && c.calender_end_time }

  before_validation :check_text_time, if: ->(c) { !c.calender_start_time && !c.calender_end_time  }
  after_validation :set_calender_day

  attr_writer :start_time_text, :end_time_text

  after_create :anysc_notify
  after_update :anysc_notify
  after_destroy :anysc_notify

  default_scope -> { where(published: true) }
  scope :available_calender, ->{ where("calender_end_time > ?", Time.current) }
  scope :sellable_calender, ->{ available_calender.where("calender_capacity > deal_appointment")}

  def available_capacity_count
    (calender_capacity - deal_appointment) < 0 ? 0 : (calender_capacity - deal_appointment)
  end

  def availabe?
    (calender_capacity - deal_appointment) > 0
  end

  def add_deal_appointment
    increment!(:deal_appointment)
  end

  def reduce_deal_appointment
    decrement!(:deal_appointment)
  end

  def calender_day_in_time_display
    day = self.calender_day.split('-').map(&:to_i)
    date = Date.new(*day)
    date.strftime("%Y年%m月%d日")
  end

  def start_time_text
    @start_time_text || self.calender_start_time.strftime('%H-%M')
  end

  def end_time_text
    @end_time_text || self.calender_end_time.strftime('%H-%M')
  end

  def start_time_display
    self.calender_start_time.strftime('%H时%M分')
  end

  def end_time_display
    self.calender_end_time.strftime('%H时%M分')
  end

  def check_text_time
    begin
      # debugger
      self.calender_start_time = Time.zone.local(*[self.calender_day, self.start_time_text].join('-').split('-'))
      self.calender_end_time = Time.zone.local(*[self.calender_day, self.end_time_text].join('-').split('-'))
    rescue ArgumentError
      self.errors.add :base, "时间输入错误，请确定后再重新输入！"
      false
    end
  end

  def set_calender_day
    unless self.calender_day
      self.calender_day = self.calender_start_time.strftime("%Y-%m-%d")
    end
  end

  def check_same_day_of_time
    unless self.calender_start_time.strftime("%Y%m%d") == self.calender_end_time.strftime("%Y%m%d")
      self.errors.add :base, "起止时间不是同一天"
    end
  end

  def check_the_time_order
    unless self.calender_start_time < self.calender_end_time
      self.errors.add :base, "结束时间不能早于开始时间"
    end
  end

  def calender_detail
    "#{start_time_display}至#{end_time_display}"
  end

  def anysc_notify
    CalenderNoticeJob.perform_later('calender', self.doctor_id)
  end

end
