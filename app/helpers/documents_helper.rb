module DocumentsHelper
  def simple_search?(query)
    !query || query.size == 1
  end

  def simple_text_value(query)
    query.nil? ? "" : query.first[1..-1]
  end

  def advanced_query_view(query)
    query.map { |term| advanced_query_term(term) }.join.html_safe
  end

  def search_path_without_query(query)
    remaining_params = request.query_parameters.except(:query)
    query_param = params[:query].dup
    query_param.delete(query.to_json)

    search_documents_path(remaining_params.merge(query: query_param))
  end

  private

  def advanced_query_term(term)
    if term.chars.first == "o"
      content_tag :span, term[1..-1], class: "search-term search-term-operator #{term[1..-1]}"
    else
      content_tag :span, term[1..-1], class: "search-term search-term-text"
    end
  end
end
