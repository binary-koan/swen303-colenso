require "rails_helper"

RSpec.describe CalculateStatistics do
  include DocumentsSpecSupport

  subject(:result) { CalculateStatistics.new.call }

  before do
    create_document!(
      xml: DocumentsSpecSupport::SAMPLE_XML
        .sub("William Colenso", "James Cook")
        .sub(/(?<=date when=")[^\"]+/, "1899-04-10")
    )
    create_document!(
      xml: DocumentsSpecSupport::SAMPLE_XML
        .sub("William Colenso", "McLean")
        .sub(/(?<=date when=")[^\"]+/, "1850-03-01")
    )
    create_document!(
      xml: DocumentsSpecSupport::SAMPLE_XML
        .sub("William Colenso", "James Cook")
        .sub(/(?<=date when=")[^\"]+/, "1867-10-11")
    )
  end

  it "calculates the number of documents in the database" do
    expect(result.document_count).to eq 3
  end

  it "finds the number of unique authors" do
    expect(result.author_count).to eq 2
  end

  it "finds the first article date" do
    expect(result.min_date).to eq Date.new(1850, 3, 1)
  end

  it "finds the last article date" do
    expect(result.max_date).to eq Date.new(1899, 4, 10)
  end
end
