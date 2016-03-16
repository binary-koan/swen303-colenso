require "rails_helper"

RSpec.describe ZipDocuments do
  include DocumentsSpecSupport

  let(:documents) { [create_document!, create_document!, create_document!] }

  let(:zip_contents) { ZipDocuments.new(documents).call }
  let(:input_stream) { Zip::InputStream.new(zip_contents) }

  it "returns file data" do
    expect(zip_contents).to be_a StringIO
  end

  it "creates an entry for each document" do
    documents.each do |document|
      expect(input_stream.get_next_entry.name).to eq document.filename
    end
  end

  it "saves the contents of each document" do
    documents.each do |document|
      expect(input_stream.get_next_entry.get_input_stream.read).to eq document.raw_xml
    end
  end
end
