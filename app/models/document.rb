class Document < BaseXClient::Model
  TEI_NAMESPACE = "http://www.tei-c.org/ns/1.0"

  def folder?
    false
  end

  def title
    title_element = dom.at_css("teiHeader titleStmt title")

    if title_element
      title_element.text.strip
    else
      "Untitled"
    end
  end

  def author
    author_element = dom.at_css("teiHeader titleStmt author")

    if author_element
      author_element.text.strip
    else
      "Anonymous"
    end
  end

  def published_date
    bibl_date || edition_date || sent_date
  rescue ArgumentError
    nil # Annoyingly some dates are unparseable
  end

  def front_matter
    TeiToHtml.new(dom.at_css("text front")).call
  end

  def body
    TeiToHtml.new(dom.at_css("text body")).call
  end

  private

  def bibl_date
    date_node = dom.at_css("teiHeader bibl date")
    return unless date_node

    Date.parse(date_node["when"])
  end

  def edition_date
    date_node = dom.at_css("teiHeader edition date")
    return unless date_node

    DateTime.parse(date_node.text.strip).to_date
  end

  def sent_date
    date_node = dom.at_css("teiHeader correspAction[type=sent] date")
    return unless date_node

    Date.parse(date_node["when"])
  end
end
