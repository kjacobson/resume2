module ApplicationHelper
  def decode(input)
    coder = HTMLEntities.new
    return coder.decode(input)
  end

  def nil_friendly_decode(input)
    if input.nil? || input.empty?
      return decode("&mdash;")
    else
      return decode(input)
    end
  end

  def friendly_date(date)
    date.strftime("%b %e, %Y")
  end
end
