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
    it "renders the search template" do
      get :search, query: "qazxy"

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
