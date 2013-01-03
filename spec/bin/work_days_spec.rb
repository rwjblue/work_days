require 'spec_helper'

describe 'work_days', :command_line do
  before do
    Bahia.command = 'work_days'
    Bahia.command_method = 'work_days'
  end

  it "prints usage without args" do
    work_days
    stdout.should == 'Usage: blarg COMMAND'
  end
end
