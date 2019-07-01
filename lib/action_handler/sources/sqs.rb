module ActionHandler
  module Sources
    class SQS
      def parametrize(event)
        records = event['Records'] || []
        records.reduce(ActionHandler::Params.new) do |params, record|
          params.merge(parse(record['body']) || {})
        end
      end

      private

      def parse(body)
        JSON.parse(body)
      end
    end
  end
end
