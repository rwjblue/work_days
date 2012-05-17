require 'date'

require_relative 'business_days/version'
require_relative 'business_days/ext/date'
require_relative 'business_days/ext/time'
require_relative 'business_days/ext/date_time'
require_relative 'business_days/ext/range'

module BusinessDays
  def self.build_holidays( start = Date.today.year - 5, stop = Date.today.year + 5)
    holidays = []
    (start..stop).each do |year|
      holidays << closest_work_day(Date.new(year, 1, 1))    # New Years
      holidays << memorial_day(year)                        # Memorial Day
      holidays << closest_work_day(Date.new(year, 7, 4))    # 4th of July
      holidays << labor_day(year)                           # Labor Day
      holidays << thanksgiving(year)                        # Thanksgiving
      holidays << closest_work_day(Date.new(year, 12, 25))  # 4th of July
    end

    holidays
  end

  def self.memorial_day(year)
    31.downto(1).each do |day|
      date = Date.new(year, 5, day)
      return date if date.monday?
    end
  end

  def self.thanksgiving(year)
    thursdays = 0
    1.upto(30).each do |day|
      date = Date.new(year, 11, day)
      thursdays += 1 if date.thursday?
      return date if thursdays == 4
    end
  end

  def self.labor_day(year)
    1.upto(30).each do |day|
      date = Date.new(year, 9, day)
      return date if date.monday?
    end
  end

  def self.holidays
    @holidays ||= build_holidays
  end

  def self.holiday?(date)
    holidays.include?(date.to_date)
  end

  def self.closest_work_day(date)
    return date.to_date.prev_day if date.saturday?
    return date.to_date.next_day if date.sunday?

    date
  end

  def self.work_day?(date)
    return false if date.sunday? || date.saturday?

    holiday?(date) ? false : true
  end

  def self.work_days_in_range(start, stop)
    working_days = []

    (start.to_date..stop.to_date).each do |date|
      working_days << date if work_day?(date)
    end

    working_days
  end
end