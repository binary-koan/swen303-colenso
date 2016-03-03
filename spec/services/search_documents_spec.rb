require "rails_helper"

RSpec.describe SearchDocuments do
  include DocumentsHelper

  def book_xml(title)
    <<-XML
    <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
      <type>Book</type>
      <title>#{title}</title>
    </teiHeader>
    XML
  end

  subject { service.call }

  context "with multiple documents in the database" do
    let!(:documents) do
      [
        create_document!(xml: book_xml("War and Peace")),
        create_document!(xml: book_xml("Huckleberry Finn")),
        create_document!(xml: book_xml("The Sokovia Accords"))
      ]
    end

    context "when neither text nor XPath is given" do
      let(:service) { SearchDocuments.new }

      it { expect { subject }.to raise_error "Must find documents by either XPath or text" }
    end

    context "when searching with a text string" do
      let(:service) { SearchDocuments.new(text: "War") }

      it { is_expected.to contain_exactly documents.first }
    end

    context "when searching with an XPath query" do
      let(:service) { SearchDocuments.new(xpath: "//title[text()='Huckleberry Finn']") }

      it { is_expected.to contain_exactly documents.second }
    end

    context "when the number of documents per page is limited" do
      let(:service) { SearchDocuments.new(text: "Book", items_per_page: 2) }

      it { is_expected.to contain_exactly documents.first, documents.second }
    end

    context "when the number of documents per page is limited and the page is specified" do
      let(:service) { SearchDocuments.new(text: "Book", items_per_page: 2, page: 2) }

      it { is_expected.to contain_exactly documents.third }
    end
  end
end
