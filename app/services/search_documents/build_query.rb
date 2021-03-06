class SearchDocuments::BuildQuery
  BuiltQuery = Struct.new(:query_text, :external_variables)

  attr_reader :terms, :file_variable_name, :query_variable_name, :query

  def initialize(terms, file_variable_name: "$file", query_variable_name: "$query_text")
    @terms = terms.dup
    @file_variable_name = file_variable_name
    @query_variable_name = query_variable_name
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

    if term == "onot"
      process_not_operator
    elsif term.chars.first == "o"
      process_operator(term[1..-1])
    elsif term.chars.first == "x"
      process_xpath(term[1..-1])
    elsif term.chars.first == "t"
      process_text(term[1..-1])
    else
      process_text(term)
    end
  end

  def process_not_operator
    query.query_text += "not("
    process_next_term
    query.query_text += ")"
  end

  def process_operator(operator)
    query.query_text += " #{operator} "
  end

  def process_xpath(value)
    xpath = add_tei_namespace(value)

    if xpath.start_with?("/")
      query.query_text += "#{file_variable_name}#{xpath}"
    else
      query.query_text += xpath
    end
  end

  def process_text(text)
    variable_name = next_query_variable_name

    query.query_text += full_text_query(variable_name)
    query.external_variables[variable_name] = text
  end

  def full_text_query(variable_name)
    "#{file_variable_name}//tei:*[. contains text {#{variable_name}} using wildcards using stemming]"
  end

  def next_query_variable_name
    @query_text_count ||= 0
    @query_text_count += 1

    "#{query_variable_name}_#{@query_text_count}"
  end

  def add_tei_namespace(xpath)
    xpath.gsub(/\/([a-z0-9_\-*]+)/, '/tei:\1')
  end
end
