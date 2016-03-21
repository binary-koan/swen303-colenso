require_relative "../../lib/basex"

BaseXClient.configure do |client|
  if Rails.env.production?
    client.host = ENV["OPENSHIFT_RUBY_IP"]
    client.port = 15005
  else
    client.host = "localhost"
    client.port = 1984
  end

  client.username = "admin"
  client.password = "admin"

  client.collection_prefix = "colenso_"
end
