module BusinessDays::WorkSchedules
  class Default
    include BusinessDays::CalculationMethods
    include BusinessDays::HolidayMethods

    private

    def observed_holidays
      [ :new_years_day,
        :memorial_day,
        :independence_day,
        :labor_day,
        :thanksgiving_day,
        :black_friday,
        :christmas_eve_day,
        :christmas_day ]
    end
  end
end
