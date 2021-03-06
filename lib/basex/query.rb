# Ruby client for BaseX.
# Works with BaseX 7.0 and later
#
# Documentation: http://docs.basex.org/wiki/Clients
#
# (C) BaseX Team 2005-12, BSD License

module BaseXClient
  class Query
    include Enumerable

    def initialize(session, query)
      @session = session
      @query_text = query
      @id = exec(0.chr, query)
      @cache = []
      @pos = 0
    end

    def each
      while more?
        yield self.next
      end
    end

    def bind(name, value, type="")
      exec(3.chr, @id + 0.chr + name + 0.chr + value + 0.chr + type)
    end

    def context(value, type="")
      exec(14.chr, @id + 0.chr + value + 0.chr + type)
    end

    def more?
      if @cache.length == 0
        @session.write(4.chr)
        @session.send(@id)
        while @session.read > 0.chr
          @cache << @session.receive
        end
        raise BaseXClient.error_from(@session.receive, @query_text) unless @session.ok?
      end

      @pos < @cache.length
    end

    def next
      if more?
        @pos += 1
        @cache[@pos - 1]
      end
    end

    def execute
      exec(5.chr, @id)
    end

    def info
      exec(6.chr, @id)
    end

    def close
      exec(2.chr, @id)
    end

    def exec(cmd, arg)
      @session.send(cmd + arg)

      result = @session.receive
      raise BaseXClient.error_from(@session.receive) unless @session.ok?

      result
    end
  end
end
