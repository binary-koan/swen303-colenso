class Document < BaseXClient::Model
  TEI_NAMESPACE = "http://www.tei-c.org/ns/1.0"

  def folder?
    false
  end

  def title
    dom.at_css("teiHeader titleStmt title").text.strip
  end

  def author
    dom.at_css("teiHeader titleStmt author").text.strip
  end

  def published_date
    bibl_date || edition_date
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
end
