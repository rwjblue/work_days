class Range
  def work_days
    WorkDays.work_days_in_range(self.first, self.last)
  end
end
