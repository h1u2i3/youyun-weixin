module WeixinCalenderHelper
  def weixin_calender(date = Date.today, &block)
    WeixinCalender.new(self, date, block).table
  end

  class WeixinCalender < Struct.new(:view, :date, :callback)
    HEADER = %w( 周一 周二 周三 周四 周五 周六 周日 )
    START_DAY = :monday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: 'calender' do
        header + week_rows
      end
    end

    def header
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day, calss: 'calender--header' }.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = ['calender--day']
      classes << 'calender--day__disable' if day < Date.today
      classes << 'calender--day__today' if day == Date.today
      classes << 'calender--day__other-month' if day.month != Date.today.month
      classes.empty? ? nil : classes.join(' ')
    end

    def weeks
      first = date.beginning_of_week(START_DAY)
      last = 2.weeks.since date.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end

  end
end
