require "rails_helper"

RSpec.describe Document do
  describe "#create!" do
    it "creates a document" do
      expect { Document.create!("test.xml", "<test/>") }.to change(Document, :count).by 1
    end
  end
end
