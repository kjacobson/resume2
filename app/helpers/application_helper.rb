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

  def auto_title
    controller = params[:controller]
    resource = controller.singularize
    case params[:action]
    when "new"
      action = "New"
    when "edit"
      action = "Editing"
    when "show"
      action = "Viewing"
    when "index"
      action = "Viewing"
      resource = controller
    else
      action = "A better resume"
      resource = ""
    end
    content_for :title, action + " " + resource
  end

  def page_title(text)
    content_for :title, text.to_s
  end
end
