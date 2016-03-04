class Document < BaseXClient::Model
  TEI_NAMESPACE = "http://www.tei-c.org/ns/1.0"

  def title
    dom.at_css("teiHeader titleStmt title").text
  end

  def author
    dom.at_css("teiHeader titleStmt author name").text
  end

  def published_date
    Date.parse(dom.at_css("teiHeader bibl date")["when"])
  end
end
