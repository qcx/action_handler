module ActionHandler
  module Instrumentation
    def run
      setup
      begin
        super
      rescue Exception => e
        exception(e)
      end
      cleanup
    end
  end
end
