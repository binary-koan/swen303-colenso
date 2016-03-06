module BaseXClient
  class BaseXError < StandardError
  end

  class NodeNotFound < BaseXError
    ERROR_CODES = [1, 5, 6]
  end

  class DatabaseNotAvailable < BaseXError
    ERROR_CODES = [2, 3, 8, 9, 11]
  end

  class InvalidIndex < BaseXError
    ERROR_CODES = [4]
  end

  class DatabaseAlreadyOpen < BaseXError
    ERROR_CODES = [7]
  end

  class DatabaseAlreadyExists < BaseXError
    ERROR_CODES = [12]
  end

  ERROR_CLASSES = [NodeNotFound, DatabaseNotAvailable, InvalidIndex, DatabaseAlreadyOpen, DatabaseAlreadyExists]

  def self.error_from(data)
    error_code = /BXDB(\d{4})/.match(data)[1].to_i

    error_class = ERROR_CLASSES.find { |klass| klass::ERROR_CODES.include?(error_code) }
    error_class ||= BaseXError

    error_class.new(data)
  end
end
