module ActionHandler
  class Base
    attr_reader :params

    def initialize(action, params)
      @action = action
      @params = params
    end

    def call
      send(@action)
      response
    end

    def self.method_missing(action, **args, &block)
      event = ActionHandler::Event.new(args[:event])
      params = ActionHandler::Parametrizer.from_event(event)
      new(action, params).call
    end

    private

    def render(args = {})
      @response = ActionHandler::Renderer.new(args).render
    end

    def response
      @response ||= render
    end
  end
end
