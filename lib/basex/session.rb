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
    attr_reader :info, :host, :port, :username, :password

    def initialize(host, port, username, password)
      @host = host
      @port = port
      @username = username
      @password = password

      connect
    end

    def execute(com)
      # send command to server
      send(com)

      # receive result
      result = receive
      @info = receive
      raise BaseXClient.error_from(@info) unless ok?

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

        attempt_to_reconnect if t.nil?

        complete << t
      end

      complete
    end

    # Sends the defined str.
    def send(str)
      write(str + 0.chr)
    end

    def send_command(cmd, arg, input)
      send(cmd + arg + 0.chr + input)
      @info = receive
      raise BaseXClient.error_from(@info) unless ok?
    end

    # Returns a single byte from the socket.
    def read
      @socket.read(1)
    end

    def write(i)
      @socket.write(i)
    rescue Errno::EPIPE
      attempt_to_reconnect
    end

    # Returns success check.
    def ok?
      read == 0.chr
    end

    private

    def connect
      # create server connection
      @socket = TCPSocket.open(host, port)

      # authenticate
      hash = Digest::MD5.new
      # response either {nonce} or {realm:nonce}
      rec = receive.split(':')

      if rec.length == 1
        hash.update(hash.hexdigest(password))
        hash.update(rec[0])
      else
        hash.update(hash.hexdigest([username, rec[0], password].join(':')))
        hash.update(rec[1])
      end

      send(username)
      send(hash.hexdigest)

      # evaluate success flag
      raise BaseXClient::BaseXError, "Access denied." unless read == 0.chr

      @char_lead_byte = "\xFF"
      @char_lead_byte.force_encoding('ASCII-8BIT')
    end

    def attempt_to_reconnect
      @socket.close
      connect

      raise BaseXClient::LostConnectionError
    end
  end
end
