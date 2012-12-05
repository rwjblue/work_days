require_relative '../../spec_helper'

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
    c.extend  BusinessDays::SpecHelpers, :holiday_helpers
    c.include BusinessDays::SpecHelpers, :holiday_helpers
end

describe BusinessDays, :holiday_helpers do
  let(:current_year) {Date.today.year}

  holidays.each do |holiday, dates|
    context "##{holiday.to_s}" do
      it "should accept a string as the year input" do
        BusinessDays.public_send(holiday, '2012')
      end

      it "should default to the current year" do
        current_year_holiday = BusinessDays.public_send(holiday, current_year)
        BusinessDays.public_send(holiday).should eq(current_year_holiday)
      end

      it "should return the proper date given a year" do
        dates.each do |date|
          date = Date.parse(date)
          BusinessDays.public_send(holiday, date.year).should eq(date)
        end
      end
    end
  end

  context "#week_day" do
    it "should be true for weekday holidays" do
      dates = holidays[:memorial_day] + holidays[:thanksgiving_day]
      dates.each do |date|
        date = Date.parse(date)

        BusinessDays.week_day?(date).should be_true
      end
    end
  end

  context "#non_work_day?" do
    it "should be true for weekend days" do
      BusinessDays.non_work_day?(Date.new(2012,12,8)).should be_true
      BusinessDays.non_work_day?(Date.new(2012,12,9)).should be_true
    end

    it "should be true for holidays" do
      default_holiday_dates.each do |date|
        date = Date.parse(date)

        BusinessDays.non_work_day?(date).should be_true
      end
    end

    it "should be false for non-holidays" do
      default_holiday_dates.each do |date|
        date = Date.parse(date) + 3
        date -= 1 if date.saturday?
        date += 1 if date.sunday?

        BusinessDays.non_work_day?(date).should be_false
      end
    end
  end

  context "#next_work_day" do
    it "should return the next non-weekend/holiday date"
  end

  context "#previous_work_day" do
    it "should return the previous non-weekend/holiday date"
  end

  context "#holiday_methods=" do
    after do
      BusinessDays.holiday_methods = nil
    end

    it "should be used to change valid holidays" do
      BusinessDays.holiday_methods = [:thanksgiving_day]

      (all_holiday_dates - holidays[:thanksgiving_day]).each do |date|
        date = Date.parse(date)

        BusinessDays.holiday?(date).should be_false
      end

      holidays[:thanksgiving_day].each do |date|
        date = Date.parse(date)

        BusinessDays.holiday?(date).should be_true
      end
    end
  end
end
