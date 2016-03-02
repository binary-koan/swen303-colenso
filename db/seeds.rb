# Load XML files (assumed to be TEI documents) from the db/data directory.
# This is deliberately excluded from the repository; you will need to create it
# and add any documents you want to add to the database.

require_relative "../config/environment"

DATA_DIRECTORY = File.expand_path("../data", __FILE__)

unless Dir.exists?(DATA_DIRECTORY)
  raise "No data found; put any XML documents to be loaded in the db/data directory"
end

Dir.glob("#{DATA_DIRECTORY}/**/*.xml").each do |filename|
  relative_filename = filename.sub(DATA_DIRECTORY, "").sub(/^\//, "")
  Document.create!(relative_filename, File.read(filename))
end
