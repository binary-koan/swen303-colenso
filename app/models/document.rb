class Document
  class << self
    def find(xpath: nil, text: nil)
      raise "Must find documents by either XPath or text" unless xpath || text
    end

    def create!(filename, xml)
      ensure_database

      BASEX_SESSION.add(filename, xml)
    end

    private

    def ensure_database
      BASEX_SESSION.execute("check colenso_documents")
    end
  end
end
