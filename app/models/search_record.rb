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

  def top_searches(ip = nil)
    sorted_searches(ip).first(5).map { |queries, count| Entry.new(queries, count) }
  end

  def all_searches(ip = nil)
    sorted_searches(ip).map { |queries, count| Entry.new(queries, count) }
  end

  def sorted_searches(ip = nil)
    return [] unless File.exists?(DB_FILE_PATH)

    query_counts = {}

    File.open(DB_FILE_PATH) do |file|
      file.each_line do |line|
        record = JSON.parse(line)
        return if ip && record["ip"] != ip

        query_counts[record["queries"]] ||= 0
        query_counts[record["queries"]] += 1
      end
    end

    # Sort query counts in reverse so largest come first
    query_counts.to_a.sort { |search1, search2| search2.second <=> search1.second }
  end
end
