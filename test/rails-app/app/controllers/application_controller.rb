class ApplicationController < ActionController::Base
  include Trailblazer::Endpoint::Rails

  directives adapter: ApplicationAdapter, protocol: ApplicationProtocol

  # Default caller to call on all the operations
  directive :invoke_class, Trailblazer::Developer::Wtf

  directive :endpoint_ctx, ->(*) { Hash(controller: self) }
  directive :domain_ctx, ->(*) { Hash(params: params) }

  directive :flow_options do
    {
      context_options: {
        aliases: { 'contract.default': :contract, 'policy.default': :policy },
        container_class: Trailblazer::Context::Container::WithAliases,
      }
    }
  end
end
