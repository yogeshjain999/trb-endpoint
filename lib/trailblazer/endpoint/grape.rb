require_relative '../endpoint'

module Trailblazer
  module Endpoint
    module Grape
      def self.included(api)
        api.extend Directive
        api.extend Directive::Defaults
        api.extend Compiler

        api.helpers Trailblazer::Endpoint::Runner do
          # Make TRB's `run_endpoint` available within route method's scope.
          def endpoint_controller
            options.fetch(:for).base # For example, `Twitter::API`
          end
        end
      end
    end
  end
end
