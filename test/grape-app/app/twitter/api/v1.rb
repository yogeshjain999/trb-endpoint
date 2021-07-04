module Twitter
  class API::V1 < Grape::API
    include Trailblazer::Endpoint::Grape

    directives protocol: API::Endpoint::Protocol, adapter: API::Endpoint::Adapter

    # Default caller to call on all the operations
    directive :invoke_class, Trailblazer::Developer::Wtf

    # Pass `api` instance in adapter & protocol `ctx` always.
    directive :endpoint_ctx,  ->(*) { Hash(api: self) }
    directive :domain_ctx,    ->(*) { Hash(params: params) }

    # Set contract alias to across all the operations.
    directive :flow_options do
      {
        context_options: {
          aliases: { 'contract.default': :contract, 'policy.default': :policy },
          container_class: Trailblazer::Context::Container::WithAliases,
        }
      }
    end

    mount Timeline  => "/timeline"
    mount Status    => "/status"
  end
end
