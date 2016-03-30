class FindIncompleteDocuments
  def initialize
  end

  def call
    BaseXClient.session.query(incomplete_documents_query).to_a
  end

  private

  def incomplete_documents_query
    <<-QUERY
    declare namespace tei = "#{Document::TEI_NAMESPACE}";

    for $file in collection("#{Document.collection}")
    where not($file//tei:titleStmt//tei:title)
      or not($file//tei:titleStmt//tei:author)
    return substring(document-uri($file), #{Document.collection.length + 2})
    QUERY
  end
end
