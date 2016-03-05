class SearchDocuments
  HEADER_PATH = "//tei:teiHeader"

  attr_reader :xpath, :text, :page, :items_per_page, :query

  def initialize(xpath: nil, text: nil, page: 1, items_per_page: 20)
    @xpath = xpath
    @text = text
    @page = page
    @items_per_page = items_per_page
  end

  def call
    raise "Must find documents by either XPath or text" unless xpath.present? || text.present?

    if text
      resolved_xpath = "//tei:*[. contains text {$query_text}]"
      declared_variables = { query_text: text }
    else
      resolved_xpath = add_tei_namespace(xpath)
      declared_variables = {}
    end

    setup_query(resolved_xpath, declared_variables)

    query_results.map { |filename, xml| Document.new(filename, xml) }
  end

  private

  def setup_query(xpath, declared_variables)
    input = wrap_query(where_path: xpath, return_path: HEADER_PATH, declared_variables: declared_variables)
    @query = BaseXClient.session.query(input)

    declared_variables.each { |name, value| query.bind("$#{name}", value) }
  end

  def wrap_query(where_path:, return_path: "", declared_variables:)
    variable_declarations = declared_variables.keys.map { |name| "declare variable $#{name} external;" }.join
    start = (page - 1) * items_per_page + 1

    <<-END
    declare namespace tei = "#{Document::TEI_NAMESPACE}";
    #{variable_declarations}

    let $results := for $file in collection("#{Document.collection}")
    where $file#{where_path}
    return [substring(document-uri($file), #{Document.collection.length + 2}), $file#{HEADER_PATH}]

    return subsequence($results, #{start}, #{items_per_page})
    END
  end

  def add_tei_namespace(xpath)
    xpath.gsub(/\/([a-z0-9_\-*]+)/, '/tei:\1')
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
