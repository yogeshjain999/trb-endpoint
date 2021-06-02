begin
  require "grape"
rescue LoadError => _
  abort "[Trailblazer::Endpoint] Add missing `grape` dependency in your Gemfile."
end

require_relative '../endpoint'

# Glue code to make `compile_endpoint` and `run_endpoint` APIs available
# within `Grape::API` and `Grape::Endpoint` respectively.
module Grape
  class API
    extend Trailblazer::Endpoint::ClassMethods

    class << self
      # TODO: Set `@_trailblazer_endpoints` on each subclass of `Grape::API`
      def set_endpoint_for(name, activity)
        @_trailblazer_endpoints ||= {} # FIXME
        @_trailblazer_endpoints[name] = activity
      end
    end
  end

  # Make TRB's `run_endpoint` available within route method's scope.
  class Endpoint
    include Trailblazer::Endpoint::InstanceMethods

    def default_endpoint_controller
      options.fetch(:for).base # For example, `Twitter::API`
    end
  end
end
