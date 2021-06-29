module Trailblazer
  module Endpoint
    # All protocol and adapter steps (authenticated, not_found etc) are
    # abstract by default and left to the user for implementation.
    # This exception would be raised at runtime in case they're not implemented.
    class StepNotDefined < RuntimeError
      def initialize(activity_name, step)
        super("{#{step.inspect}} renderer is not defined in given #{activity_name}.")
      end
    end
  end
end

require_relative "endpoint/version"
require_relative "endpoint/directive"
require_relative "endpoint/compiler"
require_relative "endpoint/runner"
require_relative "endpoint/protocol"
require_relative "endpoint/adapter"
