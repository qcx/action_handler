module ActionHandler
  class Base
    attr_reader :event, :context, :params

    def initialize(action, event, context)
      @action = action
      @event = ActionHandler::Params.new(event)
      @context = context
      @params = ActionHandler::Params.build(event, sources: self.class.sources)
    end

    def call
      send(@action)
      response
    end

    def self.method_missing(action, **args, &block)
      new(action, args[:event], args[:context]).call
    end

    private

    def render(args = {})
      @response = ActionHandler::Renderer.new(args).render
    end

    def response
      @response ||= render
    end

    def self.source(source)
      sources.push(source)
    end

    def self.sources
      @sources ||= []
    end
  end
end
