class CalculateStatistics
  Statistics = Struct.new(:document_count, :author_count, :min_date, :max_date)

  def initialize
  end

  def call
    min_date, max_date = date_range

    Statistics.new(document_count, author_count, min_date, max_date)
  end

  private

  def document_count
    Document.count
  end

  def author_count
    BaseXClient.session.query(author_query).first.to_i
  end

  def date_range
    min_date = Date.new(9999, 12, 31)
    max_date = Date.new(0, 1, 1)
    query = BaseXClient.session.query(date_query)

    query.each do |date_descriptor|
      date = Date.parse(date_descriptor)

      min_date = date if date < min_date
      max_date = date if date > max_date
    end

    [min_date, max_date]
  end

  def author_query
    <<-QUERY
    declare namespace tei = "#{Document::TEI_NAMESPACE}";

    count(distinct-values(collection("#{Document.collection}")//tei:teiHeader//tei:author//text()))
    QUERY
  end

  def date_query
    <<-QUERY
    declare namespace tei = "#{Document::TEI_NAMESPACE}";

    distinct-values(
      collection("#{Document.collection}")//tei:teiHeader//tei:bibl//tei:date/@when |
      collection("#{Document.collection}")//tei:teiHeader//tei:edition//tei:date/@when |
      collection("#{Document.collection}")//tei:teiHeader//tei:correspAction[type="sent"]//tei:date/@when
    )
    QUERY
  end
end
