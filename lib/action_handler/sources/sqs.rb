module ActionHandler
  module Sources
    class SQS
      def parametrize(event)
        records = event['Records'] || []
        records.reduce(ActionHandler::Params.new) do |params, record|
          params.merge(record['body'] || {})
        end
      end
    end
  end
end
