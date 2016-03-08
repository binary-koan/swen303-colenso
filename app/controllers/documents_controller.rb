class DocumentsController < ApplicationController
  def index
  end

  def search
    @results = SearchDocuments.new(query_terms).call
  end

  def show
    @document = Document.find(params[:id] + ".xml")
  end

  def download
    @document = Document.find(params[:id] + ".xml")

    send_data @document.raw_xml, filename: @document.filename
  end

  private

  def query_terms
    if params[:query_type] == "advanced"
      JSON.parse(params[:query])["terms"]
    elsif params[:query].start_with?("/")
      [{ "type" => "xpath", "value" => params[:query] }]
    else
      [{ "type" => "text", "value" => params[:query] }]
    end
  end
end
