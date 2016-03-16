class DocumentsController < ApplicationController
  include DocumentsHelper

  def index
  end

  def search
    search_documents(max_items: 20, return_path: SearchDocuments::TEI_HEADER_PATH)

    respond_to do |format|
      format.html

      format.json do
        content = render_to_string(partial: "search_result", collection: @results, formats: ["html"])

        render json: { content: content }
      end
    end
  end

  def download_all
    search_documents(max_items: Document.count, return_path: "")

    send_data ZipDocuments.new(@results).call.string, filename: "results.zip"
  end

  def new
  end

  def create
    filename = params[:file_path].sub(/\A\//, "")
    xml = params[:file].try!(:read)

    if filename.blank? || xml.blank?
      flash[:error] = "The upload failed. Did you specify a file path and upload a non-empty file?"

      redirect_to action: "new"
    else
      Document.create!(filename, xml)
      flash[:notice] = "Thanks! Your document was added."

      redirect_to action: "index"
    end
  end

  def show
    @document = Document.find(params[:id] + ".xml")
  end

  def download
    @document = Document.find(params[:id] + ".xml")

    send_data @document.raw_xml, filename: @document.filename
  end

  private

  def search_documents(max_items:, return_path:)
    @queries = params[:query].map { |query| JSON.parse(query) }
    @results = SearchDocuments.new(
      *@queries,
      page: params[:page] || 1,
      items_per_page: max_items,
      return_path: return_path
    ).call
  end
end
