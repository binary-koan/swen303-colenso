require "rails_helper"

RSpec.describe Document do
  SAMPLE_XML = <<-XML
  <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="Colenso-NewsL-0001">
     <teiHeader>
        <fileDesc>
           <titleStmt>
              <title>Letter: 1847 To the editor.</title>
              <author>
                 <name type="person" key="http://wtap.vuw.ac.nz/eats/entity/9614/">William Colenso</name>
              </author>
           </titleStmt>
           <publicationStmt><p/></publicationStmt>
           <sourceDesc>
              <bibl>
                 <date when="1847-04-28">1847 April 28</date>
                 <publisher>
                    <name key="http://wtap.vuw.ac.nz/eats/entity/2450/" type="organisation">New Zealand Spectator and Cook’s Strait Guardian</name>
                 </publisher>
              </bibl>
           </sourceDesc>
        </fileDesc>
        <profileDesc>
          <creation>
            <date when="1847-04-24">1847 April 24</date>
            <name key="http://wtap.vuw.ac.nz/eats/entity/44759/" type="place">Petoni</name>
          </creation>
        </profileDesc>
     </teiHeader>
     <text>
        <front>
           <p>
              <hi rend="bold">1847 To the editor. </hi>
              <hi rend="bold italic">New Zealand Spectator and Cook’s Strait Guardian</hi>
              <hi rend="bold"> 28 April.</hi>
           </p>
        </front>
        <body>
           <p rend="end">In my tent, at Petoni,</p>
           <p rend="end">Saturday evening, April 24, 1847.</p>
           <p>
              <hi rend="smallcaps">Sir</hi>,—I was not a little surprised on reading in your paper of this day’s date.
            </p>
        </body>
     </text>
  </TEI>
  XML

  let(:document) { Document.create!("test.xml", SAMPLE_XML) }

  describe ".create!" do
    it "creates a document" do
      expect { document }.to change(Document, :count).by 1
    end
  end

  describe ".find" do
    it "finds the document with the specified filename" do
      document
      expect(Document.find(document.filename)).to eq document
    end
  end

  describe "#basename" do
    it "strips the .xml extension from the filename" do
      expect(document.basename + ".xml").to eq document.filename
    end
  end

  describe "#title" do
    subject { document.title }
    it { is_expected.to eq "Letter: 1847 To the editor." }
  end

  describe "#author" do
    subject { document.author }
    it { is_expected.to eq "William Colenso" }
  end

  describe "#published_date" do
    subject { document.published_date }
    it { is_expected.to eq Date.new(1847, 4, 28) }
  end
end
