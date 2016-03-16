require "rails_helper"

RSpec.describe DocumentsController do
  include DocumentsSpecSupport

  before { create_document! }

  describe "GET index" do
    it "renders the index template" do
      get :index

      expect(response).to be_success
      expect(response).to render_template "index"
    end
  end

  describe "GET search" do
    context "with a simple query" do
      it "calls SearchDocuments with a single term" do
        expect(SearchDocuments).to receive(:new).with(
          ["tqazxy"],
          page: 1,
          items_per_page: 20,
          return_path: SearchDocuments::TEI_HEADER_PATH
        ).and_call_original

        get :search, query: [["tqazxy"].to_json]
      end

      it "passes through the given page parameter" do
        expect(SearchDocuments).to receive(:new).with(
          ["tqazxy"],
          page: "2",
          items_per_page: 20,
          return_path: SearchDocuments::TEI_HEADER_PATH
        ).and_call_original

        get :search, query: [["tqazxy"].to_json], page: 2
      end
    end

    context "with an advanced query" do
      it "calls SearchDocuments with the query parsed as JSON" do
        expect(SearchDocuments).to receive(:new).with(
          ["onot", "tqazxy"],
          page: 1,
          items_per_page: 20,
          return_path: SearchDocuments::TEI_HEADER_PATH
        ).and_call_original

        query = '["onot", "tqazxy"]'

        get :search, query: [query], query_type: "advanced"
      end
    end

    it "renders the search template" do
      get :search, query: [["tqazxy"].to_json]

      expect(response).to be_success
      expect(response).to render_template "search"
    end
  end

  describe "GET show" do
    let!(:document) { create_document!(filename: "diary.xml") }

    it "fails if the document is not found" do
      expect { get :show, id: "unknown" }.to raise_error(BaseXClient::NodeNotFound)
    end

    it "finds the document with the given base name" do
      get :show, id: "diary"

      expect(response).to be_success
      expect(response).to render_template "show"
      expect(assigns(:document)).to eq document
    end
  end

  describe "GET download" do
    let!(:document) { create_document!(filename: "diary.xml") }

    it "fails if the document is not found" do
      expect { get :download, id: "unknown" }.to raise_error(BaseXClient::NodeNotFound)
    end

    it "sends the TEI of the document with the given base name" do
      get :download, id: "diary"

      expect(response).to be_success
      expect(response.body).to eq document.raw_xml
      expect(response.header["Content-Disposition"]).to match document.filename
    end
  end
end
