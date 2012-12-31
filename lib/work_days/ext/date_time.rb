class DateTime
  def work_day?
    WorkDays.work_day?(self)
  end
end
