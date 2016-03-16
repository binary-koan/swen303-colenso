class SearchDocuments::WrapQueries
  attr_reader :where_clauses, :external_variables, :start, :items_per_page, :return_path

  def initialize(query_texts, external_variables, start:, items_per_page:, return_path:)
    @where_clauses = query_texts.map { |text| "where #{text}" }
    @external_variables = external_variables
    @start = start
    @items_per_page = items_per_page
    @return_path = return_path
  end

  def call
    <<-QUERY
    declare namespace tei = "#{Document::TEI_NAMESPACE}";
    #{variable_declarations}

    let $results := for #{SearchDocuments::FILE_VARIABLE_NAME} score $score in collection("#{Document.collection}")
    #{where_clauses.join("\n")}
    order by $score descending
    return [
      substring(document-uri(#{SearchDocuments::FILE_VARIABLE_NAME}), #{Document.collection.length + 2}),
      #{SearchDocuments::FILE_VARIABLE_NAME}#{return_path}
    ]

    return subsequence($results, #{start}, #{items_per_page})
    QUERY
  end

  private

  def variable_declarations
    external_variables.keys.map { |name| "declare variable #{name} external;" }.join
  end
end
