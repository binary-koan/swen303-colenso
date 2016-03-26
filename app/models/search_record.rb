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
end
