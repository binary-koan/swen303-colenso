require_relative "../../lib/basex"

BASEX_SESSION ||= BaseXClient::Session.new("localhost", 1984, "admin", "admin")
