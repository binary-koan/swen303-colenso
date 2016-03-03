require_relative "../../lib/basex"

BaseXClient.configure do |client|
  client.host = "localhost"
  client.port = 1984
  client.username = "admin"
  client.password = "admin"

  client.collection_prefix = "colenso_"
end
