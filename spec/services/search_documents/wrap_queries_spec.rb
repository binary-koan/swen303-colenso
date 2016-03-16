require "rails_helper"

RSpec.describe SearchDocuments::WrapQueries do
  let(:queries) do
    [
      "$file//tei:teiHeader//name[text()='William Colenso']",
      "$file//tei:teiHeader//date[text()={$query_text_1}]"
    ]
  end

  let(:external_variables) do
    { "$query_text_1" => "15 March 1847", "$unused" => "Accidental" }
  end

  let(:start) { 1 }
  let(:items_per_page) { 10 }
  let(:return_path) { "" }

  let(:service) do
    SearchDocuments::WrapQueries.new(
      queries,
      external_variables,
      start: start,
      items_per_page: items_per_page,
      return_path: return_path
    )
  end

  subject(:result) { service.call }

  it "adds where clauses for queries" do
    queries.each do |query|
      expect(result).to include "where #{query}"
    end
  end

  it "declares external variables" do
    external_variables.each do |name, _|
      expect(result).to include "declare variable #{name} external"
    end
  end

  it "returns a subsequence" do
    expect(result).to include "return subsequence($results, 1, 10)"
  end
end
