module BusinessDays::CalculationMethods
  def holiday?(date)
    observed_holidays.any? do |sym|
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
    loop do
      date = date.to_date.prev_day
      break if work_day?(date)
    end

    date
  end

  def next_work_day(date)
    loop do
      date = date.to_date.next_day
      break if work_day?(date)
    end

    date
  end

  def work_days_from(number_of_days, date)
    number_of_days.times do
      date = next_work_day(date)
    end

    date
  end

  def observed_holidays
    raise NotImplementedError, 'You must override this method.'
  end

  private

  def weekday_if_weekend(date)
    date -= 1 if date.saturday?
    date += 1 if date.sunday?

    date
  end

  def format_year(year=nil)
    year ||= Date.today.year
    year.to_i
  end

  def day_of_week_occurence(year, month, test, count=nil)
    year    = format_year(year)
    count ||= 1
    counter = 0

    1.upto(31).each do |day|
      date = Date.new(year, month, day)
      counter += 1 if date.send(test)
      return date if counter == count
    end
  end
end
