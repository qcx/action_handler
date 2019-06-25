module ActionHandler
  module Sources
    class HTTP
      KEYS = %w(queryStringParameters pathParameters body)

      def parametrize(event)
        KEYS.reduce(ActionHandler::Params.new) do |params, key|
          params.merge(parse(event[key]))
        end
      end

      private

      def parse(param)
        case param
        when String
          JSON.parse(param)
        when Hash
          param
        else
          {}
        end
      end
    end
  end
end
