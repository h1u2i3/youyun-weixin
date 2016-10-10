# == Schema Information
#
# Table name: appointments
#
#  id                    :integer          not null, primary key
#  appoint_unique_number :string
#  user_id               :integer
#  doctor_id             :integer
#  good_id               :integer
#  finished              :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  calender_id           :integer
#  cellphone             :string
#  payed                 :boolean          default(FALSE)
#  canceled              :boolean          default(FALSE)
#  service_name          :string
#  service_description   :text
#  service_price         :float
#  calender_time         :string
#  calender_place        :string
#  calender_day          :string
#  cleared               :boolean          default(FALSE)
#  refunding             :boolean          default(FALSE)
#  calender_datetime     :datetime
#

class Appointment < ActiveRecord::Base
  # include Notify

  belongs_to :doctor, counter_cache: true
  belongs_to :user, counter_cache: true
  belongs_to :calender, -> { unscope(where: :published) }
  belongs_to :good, -> { unscope(where: :published) }

  has_one :case, dependent: :destroy
  has_one :comment
  has_one :rating

  accepts_nested_attributes_for :case, reject_if: proc { |attributes| attributes['symptom'].blank? }

  validates_format_of :cellphone, with: /\A1\d{10}\z/

  validate :check_for_the_case, unless: ->(c) { c&.case }
  validate :check_for_the_symptom, if: ->(c) { c&.case && c&.case&.symptom }

  before_create :generate_unique_appointment_id
  after_create :update_service_field

  default_scope  -> { where(canceled: false) }
  scope :today, -> { where(calender_datetime: Date.today.beginning_of_day..Date.today.end_of_day)}
  scope :refunding, -> { where(payed: true, refunding: true, finished: false)}
  scope :refunded, -> { unscoped.where(payed: true, refunded: true, finished: false)}
  scope :canceled, -> { unscoped.where(canceled: true, refunded: false, refunding: false) }
  scope :finished, -> { where(finished: true) }
  scope :prepay, -> { where(finished:false, payed: false, refunding: false, canceled: false)}
  scope :ready, -> { where(payed: true, refunding: false, finished: false, canceled: false)}
  scope :wait_for_rating, -> { finished.joins("LEFT OUTER JOIN ratings ON ratings.appointment_id = appointments.id").finished.where("ratings.id is null ") }
  scope :wait_for_comment, -> { finished.joins("LEFT OUTER JOIN comments ON comments.appointment_id = appointments.id").finished.where("appointments.calender_datetime < ? and comments.id is null ", 7.days.ago) }
  scope :commenting, -> { finished.joins("LEFT OUTER JOIN comments ON comments.appointment_id = appointments.id LEFT OUTER JOIN ratings ON ratings.appointment_id = appointments.id").finished.where("(appointments.created_at < ? and comments.id is null) or ratings.id is null", 7.days.ago) }
  scope :tomorrow, -> { where(calender_datetime: Date.tomorrow.beginning_of_day..Date.tomorrow.end_of_day) }
  scope :this_week, -> { where(calender_datetime: Date.today.beginning_of_week..Date.today.end_of_week) }
  scope :this_month, -> { where(calender_datetime: Date.today.beginning_of_month..Date.today.end_of_month)}
  scope :last_month, -> { where(calender_datetime: Date.today.last_month.beginning_of_month..Date.today.last_month.end_of_month)}

  delegate :add_deal_appointment, :reduce_deal_appointment, to: :calender

  def today?
    self.calender_day == Time.current.strftime("%Y年%m月%d日")
  end

  def past?
    calender_day.gsub(/['年''月''日']/, "").to_i < Time.current.strftime("%Y%m%d").to_i
  end

  def can_cancel?
    !self.canceled && !self.payed
  end

  def can_pay?
    !self.canceled && !self.payed && !self.finished
  end

  def commenting?
    self.finished? && ( !self.rating || (!self.comment && (self.calender_datetime < 7.days.ago)))
  end

  def ready?
    self.payed? && !self.finished? && !self.canceled?
  end

  def refunding?
    self.refunding
  end

  def payed?
    self.payed
  end

  def finished?
    self.finished
  end

  def cleared?
    self.cleared
  end

  def status
    if self.finished
      'finished'
    elsif self.canceled
      'canceled'
    elsif self.payed
      'payed'
    elsif !self.canceled && !self.payed
      'prepay'
    end
  end

  def service_attributes
    {
      service_price: self.good.price,
      service_name: self.good.name,
      service_description: self.good.description
    }
  end

  def calender_attributes
    {
      calender_day: self.calender.calender_day_in_time_display,
      calender_place: self.calender.calender_place,
      calender_time: self.calender.calender_detail,
      calender_datetime: self.calender.calender_end_time
    }
  end

  def perform_payed
    if !self.payed?
      self.update_attributes(canceled: false, payed: true)
      self.add_deal_appointment
      AppointmentNoticeJob.perform_later('appointment', self.calender_day.gsub(/['年''月''日']/, '-').chomp('-'), self.id)
    end
  end

  def rating?
    self.rating.present?
  end

  def comment?
    self.comment.present?
  end

  def can_comment?
    self.rating? && !self.comment? && (self.calender_datetime < 7.days.ago)
  end

  def finish_clinic
    self.toggle!(:finished)
    AppointmentFinishedNoticeJob.perform_later(self.id)
    AppointmentRatingNotifyJob.set(wait: 1.hour).perform_later(self.id)
    AppointmentCommentNotifyJob.set(wait: 8.days).perform_later(self.id)
  end

  #####
  # do for refund request
  #####

  def prepare_for_refund
    # set refunding to true
    self.toggle!(:refunding)
  end

  def refund
    unless self.refunded
      # wx_pay refund operation
      unique_number = generate_unique_refund_number
      refund_params = {
        out_trade_no: self.appoint_unique_number,
        total_fee: (self.service_price.to_f * 100).to_i.to_s,
        refund_fee: (self.service_price.to_f * 100).to_i.to_s,
        out_refund_no: unique_number,
        op_user_id: "1298302201"
      }

      WxPay::Service.invoke_refund(refund_params)
      # change cancel column and send message to user
      AppointmentRefundNotifyJob.perform_later(self.user.openid, self.id)
      self.update_attributes(refund_no: unique_number, canceled: true, refunded: true)
    end
  end

  #####
  # endorse appointment
  #####

  def endorse(calender_id)
    if calender = Calender.find(calender_id)
      old_time = self.calender_day + self.calender_time
      self.calender = calender
      self.update_attributes(calender_attributes)
      AppointmentChangeNotifyJob.perform_later(self.user.openid, self.id, old_time)
      return true
    else
      return false
    end
  end

  private

  def generate_unique_appointment_id
    self.appoint_unique_number = "#{Time.now.to_i.to_s}#{(100000..999999).to_a.sample.to_s}"
  end

  def generate_unique_refund_number
    "r#{Time.now.to_i.to_s}#{(100000..999999).to_a.sample.to_s}"
  end

  def update_service_field
    self.update_attributes(service_attributes)
    self.update_attributes(calender_attributes)
  end

  def check_for_the_symptom
    if self.case.symptom.length < 10
      errors.add :base, "症状描述字数过少，描述内容请在10字以上"
    end
  end

  def check_for_the_case
    errors.add :base, "症状描述不能为空"
  end

end
