module DocumentsHelper
  def create_document!(filename: next_filename, xml: default_xml)
    Document.create!(filename, xml)
  end

  private

  def next_filename
    "Document#{next_file_id}.xml"
  end

  def next_file_id
    @file_id ||= 0
    @file_id += 1
  end
end
