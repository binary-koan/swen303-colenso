class ListDocuments
  attr_reader :path

  def initialize(path = "/")
    @path = path
  end

  def call
    paths = query_results.map { |name| path_fragment(name) }.uniq

    paths.map do |path|
      if path =~ /\.xml$/
        Document.find(path)
      else
        DocumentFolder.new(path)
      end
    end
  end

  private

  def query_results
    query = BaseXClient.session.query(folder_listing_query)

    results = []

    while query.more?
      results << query.next
    end

    results
  end

  def folder_listing_query
    <<-QUERY
    for $file in collection("#{Document.collection}")
    where starts-with(document-uri($file), "#{Document.collection}#{path}")
    return document-uri($file)
    QUERY
  end

  def path_fragment(full_path)
    full_path.sub(Document.collection, "").match(/^#{path}\/?[^\/]+/)[0]
  end
end
