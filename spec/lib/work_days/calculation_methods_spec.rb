require_relative '../../spec_helper'

describe WorkDays::CalculationMethods, :type => :holiday_helpers do
  let(:today)        {Date.today}
  let(:current_year) {Date.today.year}

  let(:dummy_class) do
    Class.new do
      include(WorkDays::CalculationMethods)
    end
  end

  subject{dummy_class.new}

  context "#weekend_day?" do
    let(:date) {double('date', :sunday? => false, :saturday? => false)}

    it "should be true for sundays" do
      date.should_receive(:sunday?).and_return(true)
      subject.weekend_day?(date).should be_true
    end

    it "should be true for saturdays" do
      date.should_receive(:saturday?).and_return(true)
      subject.weekend_day?(date).should be_true
    end

    it "should be false for non-saturdays/non-sundays" do
      date.should_receive(:sunday?).and_return(false)
      date.should_receive(:saturday?).and_return(false)
      subject.weekend_day?(date).should be_false
    end
    it "should be true for weekday holidays" do
      all_holiday_dates.each do |date|
        date = Date.parse(date)
        weekend_flag = date.saturday? || date.sunday?

        subject.weekend_day?(date).should == weekend_flag
      end
    end
  end

  context "#week_day?" do
    it "is true when weekend_day? is false" do
      subject.should_receive(:weekend_day?).and_return(false)
      subject.week_day?(today).should be_true
    end

    it "is false when weekend_day? is true" do
      subject.should_receive(:weekend_day?).and_return(true)
      subject.week_day?(today).should be_false
    end
  end

  context "#work_day?" do
    it "should be true for a non-holiday weekday" do
      subject.should_receive(:week_day?).and_return(true)
      subject.should_receive(:holiday?).and_return(false)

      subject.work_day?(today).should be_true
    end

    it "should be false for a holiday" do
      subject.should_receive(:week_day?).and_return(true)
      subject.should_receive(:holiday?).and_return(true)

      subject.work_day?(today).should be_false
    end

    it "should be false for a weekend" do
      subject.should_receive(:week_day?).and_return(false)
      subject.should_not_receive(:holiday?)

      subject.work_day?(today).should be_false
    end
  end

  context "#non_work_day?" do
    it "is true when work_day? is false" do
      subject.should_receive(:work_day?).and_return(false)
      subject.non_work_day?(today).should be_true
    end

    it "is false when work_day? is true" do
      subject.should_receive(:work_day?).and_return(true)
      subject.non_work_day?(today).should be_false
    end
  end

  context "#work_days_in_range" do
    let(:start_date) {random_date}
    let(:end_date)   {start_date + rand(45)}

    it "should return an array of the work days between two dates" do
      valid_work_days = []

      (start_date..end_date).each do |date|
        work_day = random_boolean

        valid_work_days << date if work_day
        subject.should_receive(:work_day?).with(date).and_return(work_day)
      end

      subject.work_days_in_range(start_date, end_date).should eq(valid_work_days)
    end
  end

  context "#holidays_in_range" do
    let(:start_date) {random_date}
    let(:end_date)   {start_date + rand(45)}

    it "should return an array of the observed holidays between two dates" do
      valid_holidays = []

      (start_date..end_date).each do |date|
        holiday = random_boolean

        valid_holidays << date if holiday
        subject.should_receive(:holiday?).with(date).and_return(holiday)
      end

      subject.holidays_in_range(start_date, end_date).should eq(valid_holidays)
    end
  end

  context "#work_days_in_month" do
    let(:date)             {random_date}
    let(:range_start_date) {Date.new(date.year, date.month, 1)}
    let(:range_end_date)   {Date.new(date.year, date.month, -1)}
    let(:range_work_days)  {rand(1..31)}

    it "should return the number of days in the month specified" do
      subject.should_receive(:work_days_in_range).with(range_start_date, range_end_date).and_return(range_work_days)
      subject.work_days_in_month(date).should eq(range_work_days)
    end
  end

  context "#monthly_work_days" do
    let(:year)          {rand(1900..2500)}
    let(:monthly_work_days) do
      Hash[(1..12).collect{|i| [Date.new(year, i, 1), i]}]
    end

    it "should return an array of the work_days in each month of the given year" do
      monthly_work_days.each do |start_date, days|
        subject.should_receive(:work_days_in_month).with(start_date).and_return(days)
      end

      subject.monthly_work_days(year).should eql(monthly_work_days.values)
    end
  end

  context "#next_work_day" do
    it "should never return the same date" do
      starting_date = random_date
      ending_date   = starting_date + 1

      subject.should_receive(:work_day?).and_return(true)
      subject.next_work_day(starting_date).should eq(ending_date)
    end

    it "iterates through each day until it finds the first non-holiday/weekend" do
      first_work_day = random_date
      starting_date  = first_work_day - 2

      subject.should_receive(:work_day?).and_return(false)
      subject.should_receive(:work_day?).with(first_work_day).and_return(true)

      subject.next_work_day(starting_date).should eq(first_work_day)
    end
  end

  context "#previous_work_day" do
    it "should never return the same date" do
      starting_date = random_date
      ending_date   = starting_date - 1

      subject.should_receive(:work_day?).and_return(true)
      subject.previous_work_day(starting_date).should eq(ending_date)
    end

    it "iterates backwards through each day until it finds the first non-holiday/weekend" do
      first_work_day = random_date
      starting_date  = first_work_day + 2

      subject.should_receive(:work_day?).and_return(false)
      subject.should_receive(:work_day?).with(first_work_day).and_return(true)

      subject.previous_work_day(starting_date).should eq(first_work_day)
    end
  end

  context "#work_days_from" do
    it "should accept the number of days and starting date" do
      should respond_to(:work_days_from)
    end

    it "should call next_work_day the specified number of times" do
      start_date      = random_date
      current_date    = start_date
      days_from_start = rand(1..100)

      days_from_start.downto(1) do
        subject.should_receive(:next_work_day).with(current_date).and_return(current_date += 1)
      end

      subject.work_days_from(days_from_start, start_date).should eq(current_date)
    end
  end

  context "#observed_holidays" do
    it "should raise an exception" do
      expect{subject.observed_holidays}.to raise_error
    end
  end
end
