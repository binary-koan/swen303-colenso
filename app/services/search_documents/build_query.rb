class SearchDocuments::BuildQuery
  BuiltQuery = Struct.new(:query_text, :external_variables)

  attr_reader :terms, :file_variable_name, :query

  def initialize(terms, file_variable_name)
    @terms = terms
    @file_variable_name = file_variable_name
    @query = BuiltQuery.new("", {})
  end

  def call
    until terms.empty?
      process_next_term
    end

    query
  end

  private

  def process_next_term
    term = terms.shift

    if term["operator"] == "not"
      process_not_operator
    elsif term["operator"].present?
      process_operator(term)
    elsif term["type"] == "xpath"
      process_xpath(term)
    else
      process_text(term)
    end
  end

  def process_not_operator
    query.query_text += "not("
    process_next_term
    query.query_text += ")"
  end

  def process_operator(term)
    query.query_text += " #{term["operator"]} "
  end

  def process_xpath(term)
    xpath = add_tei_namespace(term["value"])

    query.query_text += "#{file_variable_name}#{xpath}"
  end

  def process_text(term)
    query_variable_name = next_query_text_name

    query.query_text += "#{file_variable_name}//tei:*[. contains text {#{query_variable_name}}]"
    query.external_variables[query_variable_name] = term["value"]
  end

  def next_query_text_name
    @query_text_count ||= 0
    @query_text_count += 1

    "$query_text_#{@query_text_count}"
  end

  def add_tei_namespace(xpath)
    xpath.gsub(/\/([a-z0-9_\-*]+)/, '/tei:\1')
  end
end
