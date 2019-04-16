module ActionHandler
  module Sources
    class HTTP
      KEYS = %w(queryStringParameters pathParameters body)

      def parametrize(event)
        KEYS.reduce(ActionHandler::Params.new) do |params, key|
          params.merge(event[key] || {})
        end
      end
    end
  end
end
