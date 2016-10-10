module DoctorHelper

  Weekday = Struct.new(:id, :day) do

  end

  Month = Struct.new(:id, :month) do

  end

  def week_days
    days = []
    %w(周一 周二 周三 周四 周五 周六 周日).each_with_index do |value, index|
      days << Weekday.new(index+1, value)
    end
    days
  end

  def available_months
    months = []
    %w(一月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月).each_with_index do |value, index|
      months << Month.new(index+1, value)
    end
    months.slice(Date.today.month-1 .. 12)
  end

end
