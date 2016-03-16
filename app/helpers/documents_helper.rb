module DocumentsHelper
  def simple_search?(query)
    !query || query.size == 1
  end

  def simple_text_value(query)
    query.nil? ? "" : query.first["value"]
  end

  def advanced_query_view(query)
    query.map { |term| advanced_query_term(term) }.join.html_safe
  end

  private

  def advanced_query_term(term)
    if term["operator"]
      content_tag :span, term["operator"], class: "search-term search-term-operator #{term["operator"]}"
    else
      content_tag :span, term["value"], class: "search-term search-term-text"
    end
  end
end
