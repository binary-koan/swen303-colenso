require "rails_helper"

RSpec.describe SearchDocuments do
  include DocumentsSpecSupport

  def book_xml(title)
    <<-XML
    <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
      <type>Book</type>
      <title>#{title}</title>
    </teiHeader>
    XML
  end

  let(:search_results) { service.call }

  let(:results) { search_results.documents }
  let(:count) { search_results.count }

  context "with multiple documents in the database" do
    let!(:documents) do
      [
        create_document!(xml: book_xml("War and Peace")),
        create_document!(xml: book_xml("Huckleberry Finn")),
        create_document!(xml: book_xml("Wallace and Grommit"))
      ]
    end

    context "when no terms are given" do
      let(:service) { SearchDocuments.new([]) }

      it "Fails with an error" do
        expect { search_results }.to raise_error "You need to enter a search term!"
      end
    end

    context "when searching with a text string" do
      let(:service) { SearchDocuments.new(["tand"]) }

      it "returns documents matching the string" do
        expect(results).to contain_exactly documents.first, documents.third
        expect(count).to eq 2
      end
    end

    context "when searching with an XPath query" do
      let(:service) { SearchDocuments.new(["x//title[text()='Huckleberry Finn']"]) }

      it "returns documents matching both queries" do
        expect(results).to contain_exactly documents.second
        expect(count).to eq 1
      end
    end

    context "when searching with multiple queries" do
      let(:service) { SearchDocuments.new(["tand"], ["tWar"]) }

      it "returns documents matching both queries" do
        expect(results).to contain_exactly documents.first
        expect(count).to eq 1
      end
    end

    context "when the number of documents per page is limited" do
      let(:service) { SearchDocuments.new(["tBook"], items_per_page: 2) }

      it "returns a limited number of documents" do
        expect(results).to contain_exactly documents.first, documents.second
        expect(count).to eq 3
      end
    end

    context "when the number of documents per page is limited and the page is specified" do
      let(:service) { SearchDocuments.new(["tBook"], items_per_page: 2, page: 2) }

      it "skips the first page and returns the remaining documents" do
        expect(results).to contain_exactly documents.third
        expect(count).to eq 3
      end
    end
  end
end
