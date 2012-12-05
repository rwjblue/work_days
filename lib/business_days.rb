require 'date'

require_relative 'business_days/version'
require_relative 'business_days/holidays'
require_relative 'business_days/ext/date'
require_relative 'business_days/ext/time'
require_relative 'business_days/ext/date_time'
require_relative 'business_days/ext/range'

module BusinessDays
  extend self

  def holiday_methods=(methods)
    @holiday_methods = methods
  end

  def holiday_methods
    @holiday_methods ||= default_holiday_methods
  end

  def holiday?(date)
    holiday_methods.any? do |sym|
      next if caller.any?{|c| c =~ /`#{sym.to_s}'\z/}
      send(sym, date.year) == date
    end
  end

  def weekend_day?(date)
    date.sunday? || date.saturday?
  end

  def week_day?(date)
    !weekend_day?(date)
  end

  def work_day?(date)
    week_day?(date) && !holiday?(date)
  end

  def non_work_day?(date)
    !work_day?(date)
  end

  def work_days_in_range(start, stop)
    working_days = []

    (start.to_date..stop.to_date).each do |date|
      working_days << date if work_day?(date)
    end

    working_days
  end

  def previous_work_day(date)
    while non_work_day?(date) do
      date = date.to_date.prev_day
    end

    date
  end

  def next_work_day(date)
    while non_work_day?(date) do
      date = date.to_date.next_day
    end

    date
  end

  private

  def default_holiday_methods
    [ :new_years_day,
      :memorial_day,
      :independence_day,
      :labor_day,
      :thanksgiving_day,
      :black_friday,
      :christmas_eve_day,
      :christmas_day ]
  end

  def weekday_if_weekend(date)
    date -= 1 if date.saturday?
    date += 1 if date.sunday?

    date
  end
end
