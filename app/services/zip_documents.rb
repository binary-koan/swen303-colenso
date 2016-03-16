class ZipDocuments
  attr_reader :documents

  def initialize(documents)
    @documents = documents
  end

  def call
    Zip::OutputStream.write_buffer do |stream|
      documents.each { |document| write_document(stream, document) }
    end
  end

  private

  def write_document(stream, document)
    stream.put_next_entry(document.filename)
    stream.write(document.raw_xml)
  end
end
