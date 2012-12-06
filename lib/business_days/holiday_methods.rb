module BusinessDays::HolidayMethods
  include BusinessDays::CalculationMethods

  def new_years_day(year=nil)
    year = format_year(year)
    weekday_if_weekend(Date.new(year,1,1))
  end

  def martin_luther_king_day(year=nil)
    year = format_year(year)

    return nil if year < 1986

    day_of_week_occurence(year, 1, :monday?, 3)
  end

  def presidents_day(year=nil)
    day_of_week_occurence(year, 2, :monday?, 3)
  end

  def easter_sunday(year=nil)
    year = format_year(year)
    y = year
    a = y % 19
    b = y / 100
    c = y % 100
    d = b / 4
    e = b % 4
    f = (b + 8) / 25
    g = (b - f + 1) / 3
    h = (19 * a + b - d - g + 15) % 30
    i = c / 4
    k = c % 4
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) / 451
    month = (h + l - 7 * m + 114) / 31
    day = ((h + l - 7 * m + 114) % 31) + 1
    Date.new(year, month, day)
  end

  def memorial_day(year=nil)
    year = format_year(year)

    31.downto(1).each do |day|
      date = Date.new(year, 5, day)
      return date if date.monday?
    end
  end

  def independence_day(year=nil)
    year = format_year(year)
    weekday_if_weekend(Date.new(year,7,4))
  end

  def labor_day(year=nil)
    day_of_week_occurence(year, 9, :monday?)
  end

  def columbus_day(year=nil)
    day_of_week_occurence(year, 10, :monday?, 2)
  end

  def thanksgiving_day(year=nil)
    day_of_week_occurence(year, 11, :thursday?, 4)
  end

  def black_friday(year=nil)
    thanksgiving_day(year).next_day
  end

  def christmas_eve_day(year=nil)
    previous_work_day(christmas_day(year))
  end

  def christmas_day(year=nil)
    year = format_year(year)
    weekday_if_weekend(Date.new(year,12,25))
  end

end
