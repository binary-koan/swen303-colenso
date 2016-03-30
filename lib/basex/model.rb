module BaseXClient
  class Model
    class << self
      def create!(filename, xml)
        in_collection do
          session.add(filename, xml)
        end

        find(filename)
      end

      def find(filename, load_path: "")
        escaped_filename = filename.gsub('"', '\"')
        stored_xml = session.query("doc(\"#{collection}/#{escaped_filename}\")#{load_path}").execute
        new(filename, stored_xml)
      end

      def count
        session.query("count(collection(\"#{collection}\"))").execute.to_i
      end

      def in_collection
        session.execute("check #{collection}")
        yield session
      end

      def collection
        @collection ||= BaseXClient.collection_prefix + to_s.underscore.pluralize
      end

      private

      def session
        BaseXClient.session
      end
    end

    attr_reader :filename, :raw_xml, :dom

    def initialize(filename, xml)
      @filename = filename

      if xml.respond_to?(:to_xml)
        @raw_xml = xml.to_xml
        @dom = xml
      else
        @raw_xml = xml
        @dom = Nokogiri::XML(xml)
      end
    end

    def update!(new_xml)
      @raw_xml = new_xml

      self.class.in_collection do |session|
        session.execute("replace #{filename} #{new_xml}")
      end
    end

    def basename
      filename.sub(/^\//, "").sub(/\.xml\z/, "")
    end

    def ==(other)
      other.is_a?(self.class) && other.filename == filename && equal_xml_without_indent(other)
    end

    alias_method :eql?, :==

    private

    def equal_xml_without_indent(other)
      our_xml = dom.to_xml.gsub(/^\s+/, "")
      other_xml = dom.to_xml.gsub(/^\s+/, "")

      our_xml == other_xml
    end
  end
end
