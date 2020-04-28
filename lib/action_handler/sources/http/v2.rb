module ActionHandler
  module Sources
    class HTTP
      class V2
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
              'REQUEST_METHOD' => @event['httpMethod'],
              'QUERY_STRING' => @event['rawQueryString'],
              'CONTENT_LENGTH' => body.bytesize.to_s,
              'CONTENT_TYPE' => headers['Content-Type'] || '',
              'rack.input' => input,
            }
          end

          def body
            @body ||= if @event['body'].is_a?(Hash)
              JSON.generate(@event['body'])
            elsif @event['isBase64Encoded']
              Base64.decode64(@event['body'])
            else
              @event['body'] || ''
            end
          end

          def headers
            @headers ||= Rack::Utils::HeaderHash.new(headers_parameters)
          end

          def headers_parameters
            parametrize(@event['headers'] || {})
          end

          def parametrize(parameters)
            parameters.transform_values do |value|
              if value.is_a?(String)
                splitted = value.split(',')
                splitted.size > 1 ? splitted : value
              else
                value
              end
            end
          end

          def input
            @input ||= StringIO.new(body)
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
            } if headers['Content-Type'] == 'application/json'
          end
        end
      end
    end
  end
end
