module ActionHandler
  class Parametrizer
    EVENT_KEYS = %w(queryStringParameters pathParameters body message)
    def self.from_event(event)
      params = {}
      records = event['Records'] || []
      EVENT_KEYS.each { |key| params.merge!(event[key]) if event[key] }
      records.each { |record| params.merge!(record['body']) }
      params.with_indifferent_access
    end
  end
end
