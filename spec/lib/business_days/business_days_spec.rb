require_relative '../../spec_helper'

describe BusinessDays, :type => :holiday_helpers do
  subject {BusinessDays}

  before do
    subject.instance_variable_set(:@work_schedule, nil)
  end

  after do
    subject.instance_variable_set(:@work_schedule, nil)
  end


  context ".work_schedule=" do
    it "sets a module instance variable to the passed value" do
      subject.work_schedule = 'random value'
      subject.instance_variable_get(:@work_schedule).should eq('random value')
    end
  end

  context ".work_schedule" do
    it "returns the value of the currently set work_schedule" do
      subject.work_schedule = 'random value'
      subject.work_schedule.should eq('random value')
    end

    it "returns new WorkSchedules::Default if the work_schedule wasn't already set" do
      subject.work_schedule.should be_an_instance_of(BusinessDays::WorkSchedules::Default)
    end
  end

  context ".method_missing" do
    before do
      subject.work_schedule = double('schedule',:random_method => 'non_nil', :foo => 'bar')
    end

    after do
      subject.work_schedule = nil
    end

    it "raises NoMethodError when a method is called that the current WorkSchedule doesn't implement" do
      expect{ subject.adsfakjlk }.to raise_error(NoMethodError)
    end

    it "proxies all calls to current work_schedule" do
      subject.work_schedule.should_receive(:random_method)
      subject.work_schedule.should_receive(:foo)
      subject.random_method.should eq('non_nil')
      subject.foo.should eq('bar')
    end

    it "indicates that it responds to methods implemented by the current WorkSchedule" do
      subject.respond_to?(:random_method).should be_true
      subject.respond_to?(:foo).should be_true
    end
  end
end
