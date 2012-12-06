module BusinessDays::WorkSchedules
  class Bank
    include BusinessDays::CalculationMethods
    include BusinessDays::HolidayMethods

    def observed_holidays
      [ :new_years_day,
        :martin_luther_king_day,
        :presidents_day,
        :memorial_day,
        :independence_day,
        :labor_day,
        :columbus_day,
        :veterans_day,
        :thanksgiving_day,
        :christmas_day ]
    end
  end
end
