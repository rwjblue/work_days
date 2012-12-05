require_relative '../../spec_helper'

describe BusinessDays, :type => :holiday_helpers do
  let(:today)        {Date.today}
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

  context "#weekend_day?" do
    let(:date) {double('date', :sunday? => false, :saturday? => false)}

    it "should be true for sundays" do
      date.should_receive(:sunday?).and_return(true)
      BusinessDays.weekend_day?(date).should be_true
    end

    it "should be true for saturdays" do
      date.should_receive(:saturday?).and_return(true)
      BusinessDays.weekend_day?(date).should be_true
    end

    it "should be false for non-saturdays/non-sundays" do
      date.should_receive(:sunday?).and_return(false)
      date.should_receive(:saturday?).and_return(false)
      BusinessDays.weekend_day?(date).should be_false
    end
    it "should be true for weekday holidays" do
      all_holiday_dates.each do |date|
        date = Date.parse(date)
        weekend_flag = date.saturday? || date.sunday?

        BusinessDays.weekend_day?(date).should == weekend_flag
      end
    end
  end

  context "#week_day?" do
    it "is true when weekend_day? is false" do
      BusinessDays.should_receive(:weekend_day?).and_return(false)
      BusinessDays.week_day?(today).should be_true
    end

    it "is false when weekend_day? is true" do
      BusinessDays.should_receive(:weekend_day?).and_return(true)
      BusinessDays.week_day?(today).should be_false
    end
  end

  context "#work_day?" do
    it "should be true for a non-holiday weekday" do
      BusinessDays.should_receive(:week_day?).and_return(true)
      BusinessDays.should_receive(:holiday?).and_return(false)

      BusinessDays.work_day?(today).should be_true
    end

    it "should be false for a holiday" do
      BusinessDays.should_receive(:week_day?).and_return(true)
      BusinessDays.should_receive(:holiday?).and_return(true)

      BusinessDays.work_day?(today).should be_false
    end

    it "should be false for a weekend" do
      BusinessDays.should_receive(:week_day?).and_return(false)
      BusinessDays.should_not_receive(:holiday?)

      BusinessDays.work_day?(today).should be_false
    end
  end

  context "#non_work_day?" do
    it "is true when work_day? is false" do
      BusinessDays.should_receive(:work_day?).and_return(false)
      BusinessDays.non_work_day?(today).should be_true
    end

    it "is false when work_day? is true" do
      BusinessDays.should_receive(:work_day?).and_return(true)
      BusinessDays.non_work_day?(today).should be_false
    end
  end

  context "#next_work_day" do
    it "iterates through each day until it finds the first non-holiday/weekend" do
      first_work_day = Date.new(2012,12,5)
      starting_date  = first_work_day - 2

      BusinessDays.should_receive(:non_work_day?).twice.and_return(true)
      BusinessDays.should_receive(:non_work_day?).with(first_work_day).and_return(false)

      BusinessDays.next_work_day(starting_date).should eq(first_work_day)
    end
  end

  context "#previous_work_day" do
    it "iterates backwards through each day until it finds the first non-holiday/weekend" do
      first_work_day = Date.new(2012,12,5)
      starting_date  = first_work_day + 2

      BusinessDays.should_receive(:non_work_day?).twice.and_return(true)
      BusinessDays.should_receive(:non_work_day?).with(first_work_day).and_return(false)

      BusinessDays.previous_work_day(starting_date).should eq(first_work_day)
    end
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
