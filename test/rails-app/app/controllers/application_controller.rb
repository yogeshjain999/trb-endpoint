class ApplicationController < ActionController::Base
  include Trailblazer::Endpoint

  class << self
    def default_endpoint_adapter
      ApplicationAdapter
    end

    def default_endpoint_protocol
      ApplicationProtocol
    end
  end

  def default_endpoint_ctx
    {
      controller: self,
    }
  end

  def default_domain_ctx
    {
      params: params
    }
  end

  def default_invoke_class
    Trailblazer::Developer::Wtf
  end

  def default_flow_options
    {
      context_options: {
        aliases: { 'contract.default': :contract, 'policy.default': :policy },
        container_class: Trailblazer::Context::Container::WithAliases,
      }
    }
  end
end
