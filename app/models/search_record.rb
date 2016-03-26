module SearchRecord
  Entry = Struct.new(:queries, :count)

  DB_FILE_PATH =
    if ENV["OPENSHIFT_DATA_DIR"]
      ENV["OPENSHIFT_DATA_DIR"] + "/search_records.log"
    else
      Rails.root.join("db/local/search_records.log")
    end

  module_function

  def increment!(ip, queries)
    File.open(DB_FILE_PATH, "a") do |file|
      file << { ip: ip, queries: queries }.to_json
      file << "\n"
    end
  end

  def top_searches
    return [] unless File.exists?(DB_FILE_PATH)

    query_counts = {}

    File.open(DB_FILE_PATH) do |file|
      file.each_line do |line|
        record = JSON.parse(line)
        query_counts[record["queries"]] ||= 0
        query_counts[record["queries"]] += 1
      end
    end

    # Sort query counts in reverse so largest come first
    sorted_searches = query_counts.to_a.sort { |search1, search2| search2.second <=> search1.second }

    sorted_searches.first(5).map { |queries, count| Entry.new(queries, count) }
  end
end
