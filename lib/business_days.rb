require 'date'

require_relative 'business_days/version'
require_relative 'business_days/calculation_methods'
require_relative 'business_days/holiday_methods'
require_relative 'business_days/work_schedules/default'
require_relative 'business_days/work_schedules/bank'
require_relative 'business_days/ext/date'
require_relative 'business_days/ext/time'
require_relative 'business_days/ext/date_time'
require_relative 'business_days/ext/range'

module BusinessDays
  def self.work_schedule=(schedule)
    @work_schedule = schedule
  end

  def self.work_schedule
    @work_schedule ||= BusinessDays::WorkSchedules::Default.new
  end

  def self.method_missing(name, *args, &block)
    work_schedule.public_send(name, *args, &block)
  end
end
