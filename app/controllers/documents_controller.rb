class DocumentsController < ApplicationController
  def index
  end

  def search
    @results = search_service(params[:query]).call
  end

  def show
    @document = Document.find(params[:id] + ".xml")
  end

  def download
    @document = Document.find(params[:id] + ".xml")

    send_data @document.raw_xml, filename: @document.filename
  end

  private

  def search_service(query)
    if query =~ /\A\//
      SearchDocuments.new(xpath: query)
    else
      SearchDocuments.new(text: query)
    end
  end
end