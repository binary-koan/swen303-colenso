# Ruby client for BaseX.
# Works with BaseX 7.0 and later
#
# Documentation: http://docs.basex.org/wiki/Clients
#
# (C) BaseX Team 2005-12, BSD License

require 'socket'
require 'digest/md5'

module BaseXClient
  class Session
    attr_reader :info

    def initialize(host, port, username, pw)
      # create server connection
      @socket = TCPSocket.open(host, port)

      # authenticate
      hash = Digest::MD5.new
      # response either {nonce} or {realm:nonce}
      rec = receive.split(':')

      if rec.length == 1
        hash.update(hash.hexdigest(pw))
        hash.update(rec[0])
      else
        hash.update(hash.hexdigest([username, rec[0], pw].join(':')))
        hash.update(rec[1])
      end

      send(username)
      send(hash.hexdigest())

      # evaluate success flag
      raise "Access denied." unless read == 0.chr

      @char_lead_byte = "\xFF"
      @char_lead_byte.force_encoding('ASCII-8BIT')
    end

    def execute(com)
      # send command to server
      send(com)

      # receive result
      result = receive
      @info = receive
      raise @info unless ok?

      result
    end

    def query(cmd)
      Query.new(self, cmd)
    end

    def create(name, input)
      send_command(8.chr, name, input)
    end

    def add(path, input)
      send_command(9.chr, path, input)
    end

    def replace(path, input)
      send_command(12.chr, path, input)
    end

    def store(path, input)
      send_command(13.chr, path, input)
    end

    def close
      send("exit")
      @socket.close
    end

    # Receives a string from the socket.
    def receive
      complete = ""
      while (t = read) != 0.chr
        if t == @char_lead_byte then
          t = read
        end
        complete << t
      end

      complete
    end

    # Sends the defined str.
    def send(str)
      @socket.write(str + 0.chr)
    end

    def send_command(cmd, arg, input)
      send(cmd + arg + 0.chr + input)
      @info = receive
      raise @info unless ok?
    end

    # Returns a single byte from the socket.
    def read
      @socket.read(1)
    end

    def write(i)
      @socket.write(i)
    end

    # Returns success check.
    def ok?
      read == 0.chr
    end
  end

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

    def more
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
      if more
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
