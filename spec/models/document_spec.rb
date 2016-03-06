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
    it { is_expected.to eq without_whitespace(DocumentsSpecSupport::SAMPLE_FRONT_MATTER) }
  end

  describe "#body" do
    subject { without_whitespace(document.body) }
    it { is_expected.to eq without_whitespace(DocumentsSpecSupport::SAMPLE_BODY) }
  end
end
