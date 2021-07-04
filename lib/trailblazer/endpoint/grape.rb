require_relative '../endpoint'

module Trailblazer
  module Endpoint
    module Grape
      def self.included(api)
        api.extend Directive
        api.extend Directive::Defaults
        api.extend Compiler

        # DISCUSS: Overriding `api.inherited` here works.
        # But when `Inheried` module is extended on `api`, it doesn't.
        def api.inherited(subclass)
          super

          subclass.instance_variable_set(:@_trailblazer_endpoints, @_trailblazer_endpoints.dup)
          subclass.instance_variable_set(:@_trailblazer_directives, @_trailblazer_directives.dup)
        end

        api.helpers Trailblazer::Endpoint::Runner do
          # Make TRB's `run_endpoint` available within route method's scope.
          def endpoint_controller
            options.fetch(:for).base # For example, `Twitter::API`
          end
        end

        module Inherited
          # This doesn't get called when we do `api.extend(Inherited)`..
          #
          # def inherited(subclass)
          #   super
          #   subclass.instance_variable_set(:@_trailblazer_endpoints, @_trailblazer_endpoints.dup)
          #   subclass.instance_variable_set(:@_trailblazer_directives, @_trailblazer_directives.dup)
          # end
        end
      end
    end
  end
end
