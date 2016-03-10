require "rails_helper"

RSpec.describe TeiToHtml do
  SAMPLE_FRONT_MATTER = <<-XML
  <p>
     <hi rend="bold">1847 To the editor.</hi>
     <hi rend="bold italic">New Zealand Spectator and Cook's Strait Guardian</hi>
     <hi rend="bold">28 April.</hi>
  </p>
  XML

  SAMPLE_BODY = <<-XML
  <p rend="end">In my tent, at Petoni,</p>
  <p rend="end">Saturday evening, April 24, 1847.</p>
  <p>
     <hi rend="smallcaps">Sir</hi>, I was not a little surprised on reading in your paper of this day's date.
  </p>
  XML

  let(:service) { TeiToHtml.new(tei) }

  context "a plain paragraph" do
    let(:tei) { Nokogiri::XML("<p>Test</p>").root }

    it "translates to an html paragraph" do
      expect(service.call).to eq '<p>Test</p>'
    end
  end

  context "a paragraph with a render style" do
    let(:tei) { Nokogiri::XML('<p rend="center">Test</p>').root }

    it "translates to an html paragraph with a css class" do
      expect(service.call).to eq '<p class="text-center">Test</p>'
    end
  end

  context "a paragraph with an inner styled highlight" do
    let(:tei) { Nokogiri::XML('<p><hi rend="bold smallcaps">Test</hi> Two</p>').root }

    it "adds appropriate css classes" do
      expect(service.call).to eq '<p><span class="text-bold text-smallcaps">Test</span> Two</p>'
    end
  end
end
