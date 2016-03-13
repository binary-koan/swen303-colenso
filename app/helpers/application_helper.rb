module ApplicationHelper
  def flash_alert_class(type)
    case type
    when "error" then "danger"
    else "info"
    end
  end
end
