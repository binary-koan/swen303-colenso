module BaseXClient
  class BaseXError < StandardError
    MESSAGE = "Unknown database error."

    def initialize(original_message = "")
      super("#{self.class::MESSAGE}\n#{original_message}")
    end
  end

  class LostConnectionError < BaseXError
    MESSAGE = "Database connection was temporarily lost - please try again."
  end

  class BXDBError < BaseXError
  end

  class XPSTError < BaseXError
    MESSAGE = "Your query couldn't be understood."
  end

  class NodeNotFound < BXDBError
    MESSAGE = "Unable to find that document."
    ERROR_CODES = [1, 5, 6]
  end

  class DatabaseNotAvailable < BXDBError
    MESSAGE = "Cannot connect to the database."
    ERROR_CODES = [2, 3, 8, 9, 11]
  end

  class InvalidIndex < BXDBError
    MESSAGE = "The database appears to be corrupt."
    ERROR_CODES = [4]
  end

  class DatabaseAlreadyOpen < BXDBError
    MESSAGE = "Can't connect to the database: it is already open in another application."
    ERROR_CODES = [7]
  end

  class DatabaseAlreadyExists < BXDBError
    MESSAGE = "Can't create the database: it already exists."
    ERROR_CODES = [12]
  end

  ERROR_CLASSES = [NodeNotFound, DatabaseNotAvailable, InvalidIndex, DatabaseAlreadyOpen, DatabaseAlreadyExists]

  def self.error_from(data, additional_info="")
    if (code = error_code("BXDB", data))
      error_class = BXDBError.subclasses.find { |klass| klass::ERROR_CODES.include?(code) }
      error_class ||= BXDBError
    elsif (code = error_code("XPST", data))
      error_class = XPSTError.subclasses.find { |klass| klass::ERROR_CODES.include?(code) }
      error_class ||= XPSTError
    end

    error_class.new("#{data}\n#{additional_info}")
  end

  def self.error_code(type, data)
    code = /#{type}(\d{4})/.match(data).try!(:[], 1).to_i

    code > 0 ? code : nil
  end
end
