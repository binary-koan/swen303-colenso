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
    next_term = terms.shift

    if next_term["operator"] == "not"
      query.query_text += "not("
      process_next_term
      query.query_text += ")"
    elsif next_term["operator"].present?
      query.query_text += " #{next_term["operator"]} "
    elsif next_term["type"] == "xpath"
      query.query_text += "#{file_variable_name}#{next_term["value"]}"
    else
      query_variable_name = next_query_text_name

      query.query_text += "#{file_variable_name}//tei:*[. contains text {#{query_variable_name}}]"
      query.external_variables[query_variable_name] = next_term["value"]
    end
  end

  def next_query_text_name
    @query_text_count ||= 0
    @query_text_count += 1

    "$query_text_#{@query_text_count}"
  end
end
