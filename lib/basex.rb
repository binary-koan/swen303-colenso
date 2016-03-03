require_relative "basex/model"
require_relative "basex/query"
require_relative "basex/session"

module BaseXClient
  CONFIG_OPTIONS = %i[host port username password collection_prefix]

  CONFIG_OPTIONS.each { |option| cattr_accessor(option) }

  def self.configure
    yield self
  end

  def self.session
    @session ||= Session.new(host, port, username, password)
  end
end
