require 'date'

class BusinessDays
  VERSION = "0.0.1"

  class << self
    def build_holidays(start = 1995, stop = Date.today.year + 5)
      holidays = []
      (start..stop).each do |year|
        holidays << closest_work_day(Date.new(year, 1, 1))  # New Years
        holidays << memorial_day(year)                      # Memorial Day
        holidays << closest_work_day(Date.new(year, 7, 4))  # 4th of July
        holidays << labor_day(year)                         # Labor Day
        holidays << thanksgiving(year)                      # Thanksgiving
      end
    end

    def memorial_day(year)

    end

    def thanksgiving(year)

    end

    def labor_day(year)

    end

    def holidays
      @holidays ||= build_holidays
    end

    def holiday?(date)
      holidays.include?(date.to_date)
    end

    def closest_work_day(date)
      return date.to_date.prev_day if date.saturday?
      return date.to_date.next_day if date.sunday?

      date
    end

    def work_day?(date)
      return false if date.sunday? || date.saturday?

      holiday?(date) ? false : true
    end
  end
end