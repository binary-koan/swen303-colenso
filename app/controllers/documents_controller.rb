class DocumentsController < ApplicationController
  include DocumentsHelper

  before_action :set_document, only: [:show, :edit, :update, :download]

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
  end

  def edit
    @editing = true
  end

  def update
    validator = ValidateTei.new(params[:xml])

    if validator.call
      @document.update!(params[:xml])
      redirect_to action: "show"
    else
      flash[:error] = validator.errors.map { |error| "[Line #{error.line}] #{error.message}" }
      redirect_to action: "edit"
    end
  end

  def download
    send_data @document.raw_xml, filename: @document.filename
  end

  private

  def set_document
    @document = Document.find(params[:id] + ".xml")
  end

  def search_documents(max_items: nil, return_path: nil)
    @queries = params[:query].map { |query| JSON.parse(query) }
    @results = SearchDocuments.new(
      *@queries,
      page: params[:page] || 1,
      items_per_page: max_items,
      return_path: return_path
    ).call
  end
end
