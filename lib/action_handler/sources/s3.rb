module ActionHandler
  module Sources
    class S3
      def parametrize(event)
        records = event['Records'] || []
        records.reduce(ActionHandler::Params.new) do |params, record|
          params.merge(record['s3'] || {})
        end
      end
    end
  end
end
