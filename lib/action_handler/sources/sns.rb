module ActionHandler
  module Sources
    class SNS
      def parametrize(event)
        records = event['Records'] || []
        records.reduce(ActionHandler::Params.new) do |params, record|
          params.merge(parse(record))
        end
      end

      private

      def parse(record)
        JSON.parse(record.dig('Sns', 'Message') || "{}")
      end
    end
  end
end
