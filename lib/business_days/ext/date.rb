class Date
  def work_day?
    BusinessDays.work_day?(self)
  end
end