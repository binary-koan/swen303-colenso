module DocumentsHelper
  def searching_advanced?
    params[:query_type] == "advanced"
  end
end
