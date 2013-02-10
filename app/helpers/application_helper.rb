module ApplicationHelper
    def decode(input)
        coder = HTMLEntities.new
        return coder.decode(input)
    end

    def friendly_date(date)
      date.strftime("%b %e, %Y")
    end
end
