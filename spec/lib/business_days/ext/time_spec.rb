require_relative '../../../spec_helper'

describe Time do
  it_behaves_like "a proxy for BusinessDays.work_day?"
end
