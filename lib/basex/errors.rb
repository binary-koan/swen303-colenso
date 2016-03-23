module BaseXClient
  class BaseXError < StandardError
    MESSAGE = "Unknown database error."

    def initialize(original_message)
      super("#{self.class::MESSAGE}\n#{original_message}")
    end
  end

  class NodeNotFound < BaseXError
    MESSAGE = "Unable to find that document."
    ERROR_CODES = [1, 5, 6]
  end

  class DatabaseNotAvailable < BaseXError
    MESSAGE = "Cannot connect to the database."
    ERROR_CODES = [2, 3, 8, 9, 11]
  end

  class InvalidIndex < BaseXError
    MESSAGE = "The database appears to be corrupt."
    ERROR_CODES = [4]
  end

  class DatabaseAlreadyOpen < BaseXError
    MESSAGE = "Can't connect to the database: it is already open in another application."
    ERROR_CODES = [7]
  end

  class DatabaseAlreadyExists < BaseXError
    MESSAGE = "Can't create the database: it already exists."
    ERROR_CODES = [12]
  end

  ERROR_CLASSES = [NodeNotFound, DatabaseNotAvailable, InvalidIndex, DatabaseAlreadyOpen, DatabaseAlreadyExists]

  def self.error_from(data, additional_info="")
    error_code = /BXDB(\d{4})/.match(data).try!(:[], 1).to_i

    error_class = ERROR_CLASSES.find { |klass| klass::ERROR_CODES.include?(error_code) }
    error_class ||= BaseXError

    error_class.new("#{data}\n#{additional_info}")
  end
end
