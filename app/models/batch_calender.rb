class BatchCalender
  include ActiveModel::Model

  class << self
    def i18n_scope
      :activerecord
    end
  end

  attr_accessor :month, :weekday, :address, :start_time, :end_time, :capcity

  validates :month, :weekday, :address, :start_time, :end_time, :capcity, presence: true

  validate :check_for_weekday, :check_for_time

  private

    def check_for_weekday
      errors.add :base, "您没有选择具体哪一天" unless self.weekday.length > 1
    end

    def check_for_time
      errors.add :base, "结束时间早于开始时间" unless self.start_time < self.end_time
    end
end
