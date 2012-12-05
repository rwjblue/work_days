module BusinessDays::SpecHelpers
  def holidays
    @holidays ||= {
      :new_years_day          => %w{1980-01-01 1987-01-01 1993-01-01 2001-01-01 2006-01-02 2015-01-01},
      :martin_luther_king_day => %w{1986-01-20 1989-01-16 1993-01-18 2001-01-15 2006-01-16 2015-01-19},
      :presidents_day         => %w{1986-02-17 1989-02-20 1993-02-15 2001-02-19 2006-02-20 2015-02-16},
      :easter_sunday          => %w{1980-04-06 1987-04-19 1993-04-11 2001-04-15 2002-03-31 2015-04-05},
      :memorial_day           => %w{1980-05-26 1987-05-25 1993-05-31 2001-05-28 2006-05-29 2015-05-25},
      :independence_day       => %w{1980-07-04 1987-07-03 1993-07-05 2001-07-04 2002-07-04 2015-07-03},
      :labor_day              => %w{1980-09-01 1987-09-07 1993-09-06 2001-09-03 2006-09-04 2015-09-07},
      :columbus_day           => %w{1980-10-13 1987-10-12 1993-10-11 2001-10-08 2006-10-09 2015-10-12},
      :thanksgiving_day       => %w{1980-11-27 1987-11-26 1993-11-25 2001-11-22 2006-11-23 2015-11-26},
      :black_friday           => %w{1980-11-28 1987-11-27 1993-11-26 2001-11-23 2006-11-24 2015-11-27},
      :christmas_eve_day      => %w{1982-12-23 1987-12-24 1994-12-23 2001-12-24 2006-12-22 2015-12-24},
      :christmas_day          => %w{1982-12-24 1987-12-25 1994-12-26 2001-12-25 2006-12-25 2015-12-25},
    }
  end

  def all_holiday_dates
    @all_holiday_dates ||= holidays.values.flatten
  end

  def default_holiday_dates
    BusinessDays.send(:default_holiday_methods).collect do |holiday|
      holidays[holiday]
    end.flatten.compact
  end
end

RSpec.configure do |c|
    c.extend  BusinessDays::SpecHelpers, :type => :holiday_helpers
    c.include BusinessDays::SpecHelpers, :type => :holiday_helpers
end

