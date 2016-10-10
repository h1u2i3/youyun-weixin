module CalendarHelper

  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).table
  end

  class Calendar < Struct.new(:view, :date, :callback)

    HEADER = %w( 星期一 星期二 星期三 星期四 星期五 星期六 星期日)
    START_DAY = :monday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: 'ui celled padded table' do
        header + week_rows
      end
    end

    def header
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day, class: 'two wide' }.join.html_safe
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
      classes = ['day']
      classes << "positive" if day == Date.today
      classes << "negative" if day.month != Date.today.month
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end

  end

end
