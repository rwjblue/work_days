require_relative '../../../spec_helper'

describe Range, :type => :holiday_helpers do
  let(:start_date) { random_date}
  let(:end_date)   { start_date + rand(35)}
  let(:range)      { start_date..end_date}

  it "should call BusinessDays.work_days_in_range" do
    BusinessDays.should_receive(:work_days_in_range).with(range.first, range.last)
    range.work_days
  end
end
