module ActionHandler
  module Sources
    class HTTP
      def parametrize(event)
        @event = event
        ActionHandler::Params.new(params || {})
      end

      private

      def env
        self.class::Env.new(@event).call
      end

      def request
        Rack::Request.new(env)
      end

      def params
        path_parameters.merge(request.params) if request.request_method
      end

      def path_parameters
        @event['pathParameters'] || {}
      end

      class Env
        def initialize(event)
          @event = event
        end

        def call
          environment
            .merge(http_headers)
            .merge(request_form || {})
        end

        private

        def environment
          {
            'REQUEST_METHOD' => request_method,
            'QUERY_STRING' => query_string,
            'CONTENT_LENGTH' => body.bytesize.to_s,
            'CONTENT_TYPE' => headers['Content-Type'] || '',
            'rack.input' => input,
          }
        end

        def request_method
          @event['httpMethod'] || @event['method']
        end

        def headers
          @headers ||= Rack::Utils::HeaderHash.new(multi_headers.merge(@event['headers'] || {}))
        end

        def multi_headers
          (@event['multiValueHeaders'] || {}).map do |key, value|
            [key, value.join("\n")]
          end.to_h
        end

        def body
          @body ||= if @event['body'].is_a?(Hash)
            # Quick fix for async lambda parsing json automatically
            JSON.generate(@event['body'])
          elsif @event['isBase64Encoded']
            Base64.decode64(@event['body'])
          else
            @event['body'] || ''
          end
        end

        def input
          @input ||= StringIO.new(body)
        end

        def query_string
          @query_string ||= Rack::Utils.build_query(parsed_query_string_parameters)
        end

        def parsed_query_string_parameters
          query_string_parameters.map do |key, value|
            [Rack::Utils.unescape(key), parse_query_string_value(value)]
          end.to_h
        end

        def parse_query_string_value(value)
          case value
          when String
            Rack::Utils.unescape(value)
          when Array
            value.map { |v| parse_query_string_value(v) }
          else
            value
          end
        end

        def query_string_parameters
          @event['multiValueQueryStringParameters'] || @event['queryStringParameters'] || @event['query'] || {}
        end

        def http_headers
          headers.map do |key, value|
            ["HTTP_#{key.upcase.gsub('-', '_')}", value]
          end.to_h
        end

        def request_form
          {
            'rack.request.form_hash' => JSON.parse(body),
            'rack.request.form_input' => input
          } if headers['Content-Type'] == 'application/json' && body.to_s.length.positive?
        end
      end
    end
  end
end
