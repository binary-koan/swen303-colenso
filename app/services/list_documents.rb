class ListDocuments
  attr_reader :path

  def initialize(path)
    @path = path || "/"
  end

  def call
    paths = query_results.map { |name| path_fragment(name) }.uniq

    paths.map do |path|
      if path =~ /\.xml$/
        Document.find(path, load_path: "//*:teiHeader")
      else
        DocumentFolder.new(path)
      end
    end
  end

  private

  def query_results
    BaseXClient.session.query(folder_listing_query).to_a
  end

  def folder_listing_query
    db_path = path.start_with?("/") ? path : "/#{path}"

    <<-QUERY
    declare namespace tei = "#{Document::TEI_NAMESPACE}";

    for $file in collection("#{Document.collection}")
    where starts-with(document-uri($file), "#{Document.collection}#{db_path}")
    return document-uri($file)
    QUERY
  end

  def path_fragment(full_path)
    full_path.sub(Document.collection, "").match(/^\/?#{path}\/?[^\/]+/)[0]
  end
end
