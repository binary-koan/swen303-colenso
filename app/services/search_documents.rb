class SearchDocuments
  SearchResults = Struct.new(:documents, :count)

  class SearchError < StandardError
  end

  FILE_VARIABLE_NAME = "$file"
  QUERY_VARIABLE_NAME = "$query_text"
  TEI_HEADER_PATH = "//tei:teiHeader"

  attr_reader :queries, :page, :items_per_page, :query, :return_path

  def initialize(*queries, page: 1, items_per_page: 20, return_path: TEI_HEADER_PATH)
    @queries = queries
    @page = page.to_i
    @items_per_page = items_per_page.to_i
    @return_path = return_path
  end

  def call
    raise SearchError, "You need to enter a search term!" if queries.empty? || queries.any?(&:empty?)

    query_texts = built_queries.map(&:query_text)
    external_variables = built_queries.map(&:external_variables).reduce(&:merge)

    start = (page - 1) * items_per_page + 1
    wrapped_query = WrapQueries.new(
      query_texts,
      external_variables,
      start: start,
      items_per_page: items_per_page,
      return_path: return_path
    ).call

    setup_query(wrapped_query, external_variables)

    SearchResults.new(result_documents, result_count)
  end

  private

  def built_queries
    @built_queries ||= queries.map.with_index do |terms, index|
      BuildQuery.new(
        terms,
        file_variable_name: FILE_VARIABLE_NAME,
        query_variable_name: "#{QUERY_VARIABLE_NAME}_#{index}"
      ).call
    end
  end

  def setup_query(wrapped_query, external_variables)
    @query = BaseXClient.session.query(wrapped_query)

    external_variables.each { |name, value| query.bind(name, value) }
  end

  def result_documents
    query_result.css("> search > results > document").map do |node|
      Document.new(node.at_css("> uri").text, node.at_css("> result").first_element_child)
    end
  end

  def result_count
    query_result.at_css("> search > count").text.to_i
  end

  def query_result
    return @query_result ||= Nokogiri::XML(query.next).tap(&:remove_namespaces!)
  end
end
