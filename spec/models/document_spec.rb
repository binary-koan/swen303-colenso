require "rails_helper"

RSpec.describe Document do
  def without_whitespace(text)
    text.split("\n").map { |line| line.sub(/\A\s+/, '') }.join
  end

  let(:document) { Document.create!("diary.xml", DocumentsSpecSupport::SAMPLE_XML) }

  describe ".create!" do
    it "creates a document" do
      expect { document }.to change(Document, :count).by 1
    end
  end

  describe ".find" do
    it "finds the document with the specified filename" do
      document
      expect(Document.find(document.filename)).to eq document
    end
  end

  describe "#update!" do
    before { document }

    let(:new_xml) { "<TEI>Nothing here</TEI>" }

    it "does not create a new document" do
      expect { document.update!(new_xml) }.not_to change(Document, :count)
    end

    it "updates the cached raw_xml" do
      document.update!(new_xml)
      expect(document.raw_xml).to eq new_xml
    end

    it "updates the database record of the document" do
      document.update!(new_xml)
      expect(Document.find(document.filename).raw_xml).to eq new_xml
    end
  end

  describe "#basename" do
    it "strips the .xml extension from the filename" do
      expect(document.basename + ".xml").to eq document.filename
    end
  end

  describe "#title" do
    subject { document.title }
    it { is_expected.to eq "Letter: 1847 To the editor." }
  end

  describe "#author" do
    subject { document.author }
    it { is_expected.to eq "William Colenso" }
  end

  describe "#published_date" do
    subject { document.published_date }
    it { is_expected.to eq Date.new(1847, 4, 28) }
  end

  describe "#front_matter" do
    subject { without_whitespace(document.front_matter) }
    let(:converted_front) { TeiToHtml.new(Nokogiri::XML(DocumentsSpecSupport::SAMPLE_FRONT_MATTER).root).call }

    it { is_expected.to eq without_whitespace(converted_front) }
  end

  describe "#body" do
    subject { without_whitespace(document.body) }
    let(:converted_body) { TeiToHtml.new(Nokogiri::XML(DocumentsSpecSupport::SAMPLE_BODY).root).call }

    it { is_expected.to eq without_whitespace(converted_body) }
  end
end
