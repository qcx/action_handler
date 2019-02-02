module ActionHandler
  class Base
    attr_reader :params

    def initialize(action, params)
      @action = action
      @params = params
    end

    def call
      run
      @response || render
    end

    def self.method_missing(action, **args, &block)
      event = ActionHandler::Event.new(args[:event])
      params = ActionHandler::Parametrizer.from_event(event)
      new(action, params).call
    end

    private

    def run
      send(@action)
    end

    def render(args = {})
      @response = ActionHandler::Renderer.new(args).render
    end
  end
end
