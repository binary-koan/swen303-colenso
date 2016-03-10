class SearchDocuments
  HEADER_PATH = "//tei:teiHeader"
  FILE_VARIABLE_NAME = "$file"

  attr_reader :terms, :page, :items_per_page, :query

  def initialize(terms, page: 1, items_per_page: 20)
    @terms = terms
    @page = page.to_i
    @items_per_page = items_per_page.to_i
  end

  def call
    raise "You need to enter a search term!" if terms.nil? || terms.empty?

    query_options = BuildQuery.new(terms, FILE_VARIABLE_NAME).call
    setup_query(query_options.query_text, query_options.external_variables)

    query_results.map { |filename, xml| Document.new(filename, xml) }
  end

  private

  def setup_query(where_path, declared_variables)
    input = wrap_query(where_path: where_path, return_path: HEADER_PATH, declared_variables: declared_variables)
    @query = BaseXClient.session.query(input)

    declared_variables.each { |name, value| query.bind(name, value) }
  end

  def wrap_query(where_path:, return_path: "", declared_variables:)
    variable_declarations = declared_variables.keys.map { |name| "declare variable #{name} external;" }.join
    start = (page - 1) * items_per_page + 1

    <<-END
    declare namespace tei = "#{Document::TEI_NAMESPACE}";
    #{variable_declarations}

    let $results := for #{FILE_VARIABLE_NAME} score $score in collection("#{Document.collection}")
    where #{where_path}
    order by $score descending
    return [substring(document-uri(#{FILE_VARIABLE_NAME}), #{Document.collection.length + 2}), #{FILE_VARIABLE_NAME}#{HEADER_PATH}]

    return subsequence($results, #{start}, #{items_per_page})
    END
  end

  def query_results
    results = []

    while query.more?
      results << parse_result(query.next)
    end

    results
  end

  def parse_result(result)
    match = /\A\["(?<filename>[^"]+)", (?<xml>.+)\]\z/m.match(result)

    [match[:filename], match[:xml]]
  end
end
