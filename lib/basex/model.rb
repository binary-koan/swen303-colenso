module BaseXClient
  class Model
    class << self
      def create!(filename, xml)
        in_collection do
          session.add(filename, xml)
        end
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
  end
end
