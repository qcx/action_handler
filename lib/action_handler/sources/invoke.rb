module ActionHandler
  module Sources
    class Invoke
      KEYS = %w(queryStringParameters pathParameters body Records)

      def parametrize(event)
        ActionHandler::Params.new(event.except(*KEYS))
      end
    end
  end
end
