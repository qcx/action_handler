module ActionHandler
  class Renderer
    CONTENT_TYPES = {
      json: 'application/json',
      html: 'text/html'
    }

    def initialize(args = {})
      @content_type = args.slice(*CONTENT_TYPES.keys).keys.first&.to_sym
      @content = args[@content_type]
      @status = args[:status] || (@content ? 200 : 204)
      @headers = args[:headers] || {}
    end

    def render
      { statusCode: @status, body: body, headers: headers }.compact
    end

    private

    def body
      @content_type == :json ? @content.to_json : @content
    end

    def content_type_header
      { 'Content-Type' => (CONTENT_TYPES[@content_type] if @content_type) }
    end

    def headers
      content_type_header.merge(@headers).compact
    end
  end
end
