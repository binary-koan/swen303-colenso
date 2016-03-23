class ValidateTei
  SCHEMA_PATH = Rails.root.join("config/schemas")
  SCHEMA_FILENAME = "tei_lite.xsd"

  attr_reader :xml, :errors

  def initialize(xml)
    @xml = xml
    @errors = []
  end

  def call
    @errors = schema.validate(xml_document)

    @errors.empty?
  end

  private

  def xml_document
    Nokogiri::XML(xml)
  end

  def schema
    Dir.chdir(SCHEMA_PATH) do
      Nokogiri::XML::Schema(File.read(SCHEMA_FILENAME))
    end
  end
end
