# WorkDays

Calculate the number of business days in a given period.  Also, add convenience methods to Range, Date, and Time.

## Installation

Add this line to your application's Gemfile:

    gem 'work_days'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install work_days

## Usage

Use your own custom work schedule by creating a class implementing 
your custom holiday methods and including the WorkDays::CalculationMethods module
(and optionally the WorkDays::HolidayMethods module for a few of the presets). 

    class SampleSchedule
      WorkDays::CalculationMethods
      WorkDays::HolidayMethods

      def observed_holidays
        [:new_years_day, :christmas_day]
      end
    end

Then tell the library to use your new schedule:

    WorkDays.work_schedule = SampleSchedule.new

You can also use a few pre-built schedules (WorkDays::WorkSchedules::Default, WorkDays::WorkSchedules::Bank).

By default a day is considered a work day as long as it is a week day and it isn't a holiday.
You can configure your own week days by overriding the week_day? method in your work schedule class.

### Methods

These methods can be called either on an instance of your work schedule class or directly
on the WorkDays module (as long as you set the WorkDays.work_schedule).

#### work_day?(date)
  Returns true for week days as long as it isn't a holiday.
#### non_work_day?(date)
  The opposite of work_day?.
#### work_days_in_range(start_date, end_date)
  Returns an array of the work days between the start and end dates.
#### work_days_in_month(date)
  Returns an array of the work days for the year and month of the passed in date.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
