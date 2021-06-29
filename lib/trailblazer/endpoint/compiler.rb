require_relative "directive"
require_relative "dsl"

module Trailblazer
  module Endpoint
    module Compiler
      def self.extended(base)
        base.initial_endpoint_setup
      end

      def compile_endpoint(
        name,
        domain: name,
        protocol: get_directive_for(:protocol).(exec_context: self),  # Trailblazer::Option.call
        adapter: get_directive_for(:adapter).(exec_context: self)    # Trailblazer::Option.call
      )
        adapter = patch_adapter(adapter, domain: domain, protocol: protocol)

        set_endpoint_for(name, adapter)
        DSL.new(self, name, domain: domain, protocol: protocol, adapter: adapter)
      end

      # Replace domain & protocol template with user defined activities.
      def patch_adapter(adapter, domain:, protocol:)
        Class.new(adapter) do
          step Subprocess(
            protocol,
            patch: -> {
              step Subprocess(
                domain
              ), inherit: true, id: :domain, replace: :domain
            }
          ), inherit: true, id: :protocol, replace: :protocol
        end
      end

      def initial_endpoint_setup
        @_trailblazer_endpoints = {}
      end

      def set_endpoint_for(name, activity)
        @_trailblazer_endpoints[name] = activity
      end

      def get_endpoint_for(name)
        @_trailblazer_endpoints.fetch(name)
      end
    end
  end
end
