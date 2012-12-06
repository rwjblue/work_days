require_relative '../../spec_helper'

describe BusinessDays::HolidayMethods, :type => :holiday_helpers do
  let(:today)        {Date.today}
  let(:current_year) {Date.today.year}

  let(:dummy_class) do
    Class.new do
      include(BusinessDays::HolidayMethods)

      def observed_holidays
        [:christmas_day]
      end
    end
  end

  holidays.each do |holiday, dates|
    context "##{holiday.to_s}" do
      subject {dummy_class.new}

      it "should accept a string as the year input" do
        subject.public_send(holiday, '2012')
      end

      it "should default to the current year" do
        current_year_holiday = subject.public_send(holiday, current_year)
        subject.public_send(holiday).should eq(current_year_holiday)
      end

      it "should return the proper date given a year" do
        dates.each do |date|
          date = Date.parse(date)
          subject.public_send(holiday, date.year).should eq(date)
        end
      end
    end
  end
end
