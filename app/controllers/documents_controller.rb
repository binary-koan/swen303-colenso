class DocumentsController < ApplicationController
  include DocumentsHelper

  before_action :set_document, only: [:show, :edit, :update, :download]

  rescue_from BaseXClient::BaseXError, SearchDocuments::SearchError, with: :display_error

  def display_error(error)
    flash[:error] = error.message
    redirect_to action: "index"
  end

  def index
  end

  def browse
    @browse_path = browse_paths.map { |path| DocumentFolder.new(path) }
    @results = ListDocuments.new(params[:folder]).call
  end

  def statistics
    @statistics = CalculateStatistics.new.call
    @top_searches = SearchRecord.top_searches
    @top_searches_here = SearchRecord.top_searches(request.ip)
  end

  def search
    search_documents(max_items: 20, return_path: SearchDocuments::TEI_HEADER_PATH)

    respond_to do |format|
      format.html

      format.json do
        content = render_to_string(partial: "document_in_list", collection: @results, formats: ["html"])

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

    if params[:text]
      xml = params[:text]
    else
      xml = params[:file].try!(:read)
    end

    @sent_filename = params[:file_path]
    @sent_xml = xml

    if filename.blank? || xml.blank?
      flash.now[:error] = "The upload failed. Did you specify a file path and upload a non-empty file?"

      render "new"
    else
      errors = validate_tei(xml)

      if errors.present?
        flash.now[:error] = ["Your document couldn't be uploaded because it is not valid TEI."] + errors

        render "new"
      else
        new_document = Document.create!(filename, xml)
        flash[:notice] = "Thanks! Your document was added."

        redirect_to document_path(new_document.basename)
      end
    end
  end

  def show
  end

  def edit
    @editing = true
  end

  def update
    errors = validate_tei(params[:xml])

    if errors.present?
      flash.now[:error] = errors

      @editing = true
      @sent_xml = params[:xml]

      render "edit"
    else
      @document.update!(params[:xml])

      redirect_to action: "show"
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
    SearchRecord.increment!(request.ip, @queries)

    service = SearchDocuments.new(
      *@queries,
      page: params[:page] || 1,
      items_per_page: max_items,
      return_path: return_path
    )

    search_results, time = run_recording_time { service.call }

    @results = search_results.documents
    @result_count = search_results.count
    @search_time = time
  end

  def validate_tei(xml)
    validator = ValidateTei.new(xml)
    validator.call

    validator.errors.map { |error| "[Line #{error.line}] #{error.message}" }
  end

  def browse_paths
    whole_path = params[:folder] || "/"

    whole_path.split("/").inject([]) do |paths, current|
      if paths.last && paths.last.end_with?("/")
        paths << "#{paths.last}#{current}"
      else
        paths << "#{paths.last}/#{current}"
      end
    end
  end

  def run_recording_time
    start_time = Time.now
    result = yield

    [result, Time.now - start_time]
  end
end
