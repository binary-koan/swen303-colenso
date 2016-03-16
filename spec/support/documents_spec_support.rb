module DocumentsSpecSupport
  SAMPLE_FRONT_MATTER = <<-XML
  <front>
    <p>
       <hi rend="bold">1847 To the editor.</hi>
       <hi rend="bold italic">New Zealand Spectator and Cook's Strait Guardian</hi>
       <hi rend="bold">28 April.</hi>
    </p>
  </front>
  XML

  SAMPLE_BODY = <<-XML
  <body>
    <p rend="end">In my tent, at Petoni,</p>
    <p rend="end">Saturday evening, April 24, 1847.</p>
    <p>
       <hi rend="smallcaps">Sir</hi>, I was not a little surprised on reading in your paper of this day's date.
    </p>
  </body>
  XML

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
        #{SAMPLE_FRONT_MATTER}
        #{SAMPLE_BODY}
     </text>
  </TEI>
  XML

  def create_document!(filename: next_filename, xml: SAMPLE_XML)
    Document.create!(filename, xml)
  end

  private

  def next_filename
    "documents/Document#{next_file_id}.xml"
  end

  def next_file_id
    @file_id ||= 0
    @file_id += 1
  end
end
