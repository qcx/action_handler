module ActionHandler
  module Instrumentation
    def call
      setup
      begin
        super
      rescue Exception => e
        exception(e)
      end
      cleanup
      response
    end
  end
end
