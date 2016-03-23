require "rails_helper"

RSpec.describe ValidateTei do
  let(:service) { ValidateTei.new(xml) }

  context "with a valid TEI document" do
    let(:xml) { DocumentsSpecSupport::SAMPLE_XML }

    it "returns true" do
      expect(service.call).to eq true
    end

    it "has no errors" do
      service.call
      expect(service.errors).to be_empty
    end
  end

  context "with an XML syntax error" do
    let(:xml) { DocumentsSpecSupport::SAMPLE_XML.sub("<teiHeader>", "<teiHeader//>") }

    it "returns false" do
      expect(service.call).to eq false
    end

    it "has syntax errors" do
      service.call
      expect(service.errors.size).to be > 0
      expect(service.errors).to be_all { |e| e.is_a?(Nokogiri::SyntaxError) }
    end
  end

  context "with an invalid TEI tag" do
    let(:xml) { DocumentsSpecSupport::SAMPLE_XML.gsub("<teiHeader", "<teiHead") }

    it "returns false" do
      expect(service.call).to eq false
    end

    it "has syntax errors" do
      service.call
      expect(service.errors.size).to be > 0
      expect(service.errors).to be_all { |e| e.is_a?(Nokogiri::SyntaxError) }
    end
  end
end