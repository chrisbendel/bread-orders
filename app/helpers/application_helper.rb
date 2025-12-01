module ApplicationHelper
  def nice_date(value)
    l(value, format: :nice_date) if value
  end

  def nice_datetime(value)
    l(value, format: :nice_datetime) if value
  end
end
