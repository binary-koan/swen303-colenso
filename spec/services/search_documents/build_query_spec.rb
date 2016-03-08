require "rails_helper"

RSpec.describe SearchDocuments::BuildQuery do
  let(:service) { SearchDocuments::BuildQuery.new(terms, "$file") }

  subject(:query) { service.call }

  context "with a simple text query" do
    let(:terms) { [{ "type" => "text", "value" => "Diary" }] }

    it "builds a 'contains text' query" do
      expect(query.query_text).to eq "$file//tei:*[. contains text {$query_text_1}]"
    end

    it "sets a query text variable" do
      expect(query.external_variables).to eq "$query_text_1" => "Diary"
    end
  end

  context "with an xpath query" do
    let(:terms) { [{ "type" => "xpath", "value" => "//title" }] }

    it "adds the xpath to the query text" do
      expect(query.query_text).to eq "$file//title"
    end

    it "does not set an external variable" do
      expect(query.external_variables).to be_empty
    end
  end

  context "with a negated query" do
    let(:terms) { [{ "operator" => "not" }, { "type" => "xpath", "value" => "//title" }] }

    it "wraps the next term in not()" do
      expect(query.query_text).to eq "not($file//title)"
    end
  end

  context "with a complex query" do
    let(:terms) do
      [
        { "operator" => "not" },
        { "type" => "text", "value" => "Diary" },
        { "operator" => "and" },
        { "type" => "text", "value" => "Colenso" }
      ]
    end

    it "builds the query text correctly" do
      expect(query.query_text).to eq "not($file//tei:*[. contains text {$query_text_1}]) and $file//tei:*[. contains text {$query_text_2}]"
    end

    it "sets multiple external variables" do
      expect(query.external_variables).to eq "$query_text_1" => "Diary", "$query_text_2" => "Colenso"
    end
  end
end
