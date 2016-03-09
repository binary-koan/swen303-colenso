class DocumentsController < ApplicationController
  include DocumentsHelper

  def index
  end

  def search
    @query_terms = build_query_terms
    @results = SearchDocuments.new(@query_terms).call
  end

  def show
    @document = Document.find(params[:id] + ".xml")
  end

  def download
    @document = Document.find(params[:id] + ".xml")

    send_data @document.raw_xml, filename: @document.filename
  end

  private

  def build_query_terms
    if searching_advanced?
      JSON.parse(params[:query])["terms"]
    elsif params[:query].try!(:start_with?, "/")
      [{ "type" => "xpath", "value" => params[:query] }]
    else
      [{ "type" => "text", "value" => params[:query] }]
    end
  end
end
