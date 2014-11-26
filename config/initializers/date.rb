class Date
  def next_business_day
    days_to_add = [1,1,1,1,1,3,2]
    self + days_to_add[wday].days
  end
end