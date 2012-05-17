class Range
  def work_days
    BusinessDays.work_days_in_range(self.first, self.last)
  end
end