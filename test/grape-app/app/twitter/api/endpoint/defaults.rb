require 'active_support/concern'

module Twitter::API::Endpoint
  module Defaults
    extend ActiveSupport::Concern

    included do
      helpers do
        # Pass `api` instance always in adapter & protcol `ctx`.
        def default_endpoint_ctx
          {
            api: self
          }
        end

        def default_domain_ctx
          {
            params: params
          }
        end

        # Set contract alias to across all the operations.
        def default_flow_options
          {
            context_options: {
              aliases: { 'contract.default': :contract, 'policy.default': :policy },
              container_class: Trailblazer::Context::Container::WithAliases,
            }
          }
        end

        # Default caller to call on all the operations
        def default_invoke_class
          Trailblazer::Developer::Wtf
        end
      end
    end

    class_methods do
      def default_endpoint_protocol
        Protocol
      end

      def default_endpoint_adapter
        Adapter
      end
    end
  end
end
