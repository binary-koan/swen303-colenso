require "rails_helper"

RSpec.describe SearchDocuments::BuildQuery do
  let(:service) { SearchDocuments::BuildQuery.new(terms) }

  subject(:query) { service.call }

  context "with a simple text query" do
    let(:terms) { ["tDiary"] }

    it "builds a 'contains text' query" do
      expect(query.query_text).to eq "$file//tei:*[. contains text {$query_text_1} using wildcards using stemming]"
    end

    it "sets a query text variable" do
      expect(query.external_variables).to eq "$query_text_1" => "Diary"
    end
  end

  context "with an xpath query" do
    let(:terms) { ["x//title"] }

    it "adds namespaced xpath to the query text" do
      expect(query.query_text).to eq "$file//tei:title"
    end

    it "does not set an external variable" do
      expect(query.external_variables).to be_empty
    end
  end

  context "with a negated query" do
    let(:terms) { ["onot", "x//title"] }

    it "wraps the next term in not()" do
      expect(query.query_text).to eq "not($file//tei:title)"
    end
  end

  context "with a complex query" do
    let(:terms) { ["onot", "tDiary", "oand", "tColenso"] }

    it "builds the query text correctly" do
      expect(query.query_text).to eq "" +
        "not($file//tei:*[. contains text {$query_text_1} using wildcards using stemming]) and " +
        "$file//tei:*[. contains text {$query_text_2} using wildcards using stemming]"
    end

    it "sets multiple external variables" do
      expect(query.external_variables).to eq "$query_text_1" => "Diary", "$query_text_2" => "Colenso"
    end
  end

  context "with custom variable names" do
    let(:terms) { ["tDiary"] }
    let(:service) { SearchDocuments::BuildQuery.new(terms, file_variable_name: "$document", query_variable_name: "$text_query_1") }

    it "alters the query variable name" do
      expect(query.query_text).to include "$text_query_1_1"
      expect(query.query_text).not_to include "$query_text"
    end

    it "alters the file variable name" do
      expect(query.query_text).to include "$document"
      expect(query.query_text).not_to include "$file"
    end
  end
end
