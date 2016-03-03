module BaseXClient
  class Model
    class << self
      def create!(filename, xml)
        in_collection do
          session.add(filename, xml)
        end

        find(filename)
      end

      def find(filename)
        #TODO escape filename
        stored_xml = session.query("doc(\"#{collection}/#{filename}\")").execute
        new(filename, stored_xml)
      end

      def count
        session.query("count(collection(\"#{collection}\"))").execute.to_i
      end

      def in_collection
        session.execute("check #{collection}")
        yield
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
      @raw_xml = xml
      @dom = Nokogiri::XML(xml)
    end

    def ==(other)
      other.is_a?(self.class) && other.raw_xml == raw_xml && other.filename == filename
    end

    alias_method :eql?, :==
  end
end
