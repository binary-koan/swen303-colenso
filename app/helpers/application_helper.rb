module ApplicationHelper
  def flash_messages(type, messages)
    messages = [messages] unless messages.respond_to?(:each)

    messages.map do |message|
      content_tag "div", message, class: "alert alert-#{flash_alert_class(type)}"
    end.join.html_safe
  end

  def flash_alert_class(type)
    case type
    when "error" then "danger"
    else "info"
    end
  end
end
