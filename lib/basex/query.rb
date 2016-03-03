# Ruby client for BaseX.
# Works with BaseX 7.0 and later
#
# Documentation: http://docs.basex.org/wiki/Clients
#
# (C) BaseX Team 2005-12, BSD License

module BaseXClient
  class Query
    def initialize(s, q)
      @session = s
      @id = exec(0.chr, q)
      @cache = []
      @pos = 0
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
        raise @session.receive unless @session.ok?
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
      raise @session.receive unless @session.ok?

      result
    end
  end
end
