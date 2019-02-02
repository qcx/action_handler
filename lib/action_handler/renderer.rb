module ActionHandler
  class Renderer
    CONTENT_TYPES = {
      json: 'application/json',
      html: 'text/html'
    }

    def initialize(args = {})
      @content_type = args.slice(*CONTENT_TYPES.keys).keys.first&.to_sym
      @content = args[@content_type]
      @status = args[:status] || @content ? 200 : 204
    end

    def render
      { statusCode: @status, body: body, headers: headers }.compact
    end

    private

    def body
      @content_type == :json ? @content.to_json : @content
    end

    def headers
      { 'Content-Type' => CONTENT_TYPES[@content_type] } if @content_type
    end
  end
end
