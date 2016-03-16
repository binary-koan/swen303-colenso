class DocumentsController < ApplicationController
  include DocumentsHelper

  def index
  end

  def search
    @queries = params[:query].map { |query| JSON.parse(query) }
    @results = SearchDocuments.new(*@queries, page: params[:page] || 1).call

    respond_to do |format|
      format.html

      format.json do
        content = render_to_string(partial: "search_result", collection: @results, formats: ["html"])

        render json: { content: content }
      end
    end
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
end
