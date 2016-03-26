class Document < BaseXClient::Model
  TEI_NAMESPACE = "http://www.tei-c.org/ns/1.0"

  DEFAULT_TITLE = "Untitled"
  DEFAULT_AUTHOR = "Anonymous"

  def folder?
    false
  end

  def title
    title_element = dom.at_css("titleStmt title")

    if title_element
      title_element.text.strip
    else
      DEFAULT_TITLE
    end
  end

  def author
    author_element = dom.at_css("titleStmt author")

    if author_element
      author_element.text.strip
    else
      DEFAULT_AUTHOR
    end
  end

  def published_date
    bibl_date || edition_date || sent_date
  rescue ArgumentError
    nil # Annoyingly some dates are unparseable
  end

  def front_matter
    @front_matter ||= TeiToHtml.new(front_matter_node).call
  end

  def body
    @body ||= TeiToHtml.new(body_node).call
  end

  def word_count
    front_matter_node.text.split(/\s+/).size + body_node.text.split(/\s+/).size
  end

  private

  def bibl_date
    date_node = dom.at_css("bibl date")
    return unless date_node

    Date.parse(date_node["when"])
  end

  def edition_date
    date_node = dom.at_css("edition date")
    return unless date_node

    DateTime.parse(date_node.text.strip).to_date
  end

  def sent_date
    date_node = dom.at_css("correspAction[type=sent] date")
    return unless date_node

    Date.parse(date_node["when"])
  end

  def front_matter_node
    dom.at_css("text front")
  end

  def body_node
    dom.at_css("text body")
  end
end
