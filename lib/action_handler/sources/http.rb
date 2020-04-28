module ActionHandler
  module Sources
    class HTTP
      SOURCES = {
        '1.0' => ActionHandler::Sources::HTTP::V1,
        '2.0' => ActionHandler::Sources::HTTP::V2
      }

      def parametrize(event)
        @event = event
        params
      end

      private

      def version
        @event['version']
      end

      def source_klass
        SOURCES[version]
      end

      def source
        source_klass.new
      end

      def params
        SOURCES.key?(version) ? source.parametrize(@event) : ActionHandler::Params.new
      end
    end
  end
end
