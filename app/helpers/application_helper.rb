module ApplicationHelper
  def formatted_messages(flash)
    all_messages = []

    flash.each do |type, messages|
      messages = [messages] unless messages.respond_to?(:each)
      all_messages += messages.map { |message| format_message(type, message) }
    end

    all_messages
  end

  def format_message(type, message)
    title, details = message.split("\n", 2)

    { title: title, details: details, type: type }
  end

  def message_id(message)
    Digest::MD5.hexdigest(message.to_s)
  end

  def flash_alert_class(type)
    case type
    when "error" then "danger"
    else "info"
    end
  end
end
