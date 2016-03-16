module DocumentsHelper
  def simple_search?(query)
    !query || query.size == 1
  end

  def simple_text_value(query)
    query.nil? ? "" : query.first["value"]
  end
end
