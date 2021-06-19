# frozen_string_literal: true

require "trailblazer/activity/dsl/linear"
require "trailblazer/context"

module Trailblazer
  module Endpoint
    FastTrack = Trailblazer::Activity::FastTrack

    # All protocol and adapter steps (authenticated, not_found etc) are
    # blank by default and left to the user for implementation.
    # This exception would be raised at runtime in case they're not implemented.
    class StepNotDefined < RuntimeError
      def initialize(activity_name, step)
        super("{#{step.inspect}} renderer is not defined in given #{activity_name}.")
      end
    end

    def self.included(klass)
      klass.include(InstanceMethods)
      klass.extend(ClassMethods)
      klass.extend(Inherited)

      klass.initial_endpoint_setup
    end

    module InstanceMethods
      def run_endpoint(
        activity,
        controller: default_endpoint_controller,
        invoke_class: default_invoke_class,
        **options
      )
        invoke_class.invoke(
          controller.get_endpoint_for(activity),
          [default_ctx(**options), default_flow_options]
        )
      end

      def default_endpoint_controller
        self.class
      end

      def default_invoke_class
        Trailblazer::Activity::TaskWrap
        # Trailblazer::Developer::Wtf
      end

      def default_ctx(domain_ctx: default_domain_ctx, endpoint_ctx: default_endpoint_ctx, **)
        Trailblazer::Context(
          {
            domain_ctx: default_domain_ctx.merge(domain_ctx),
            endpoint_ctx: default_endpoint_ctx.merge(endpoint_ctx)
          }
        )
      end

      def default_flow_options
        {}
      end

      def default_endpoint_ctx
        {}
      end

      def default_domain_ctx
        {}
      end
    end

    module ClassMethods
      def compile_endpoint(
        name,
        domain: name,
        protocol: default_endpoint_protocol,
        adapter: default_endpoint_adapter,
        &success_block
      )
        adapter = patch_adapter(adapter, domain: domain, protocol: protocol, &success_block)

        set_endpoint_for(name, adapter)
        DSL.new(self, name, domain: domain, protocol: protocol, adapter: adapter)
      end

      def default_endpoint_adapter
        Adapter
      end

      def default_endpoint_protocol
        Protocol
      end

      # private

      def initial_endpoint_setup
        @_trailblazer_endpoints = {}
      end

      def patch_adapter(adapter, domain:, protocol:, &success_block)
        Class.new(adapter) do
          step Subprocess(
            protocol,
            patch: -> {
              step Subprocess(
                domain
              ), inherit: true, id: :domain, replace: :domain
            }
          ), inherit: true, id: :protocol, replace: :protocol

          step success_block, id: :success, replace: :success, inherit: true if success_block
        end
      end

      def set_endpoint_for(name, activity)
        @_trailblazer_endpoints[name] = activity
      end

      def get_endpoint_for(name)
        @_trailblazer_endpoints.fetch(name)
      end
    end

    module Inherited
      def inherited(subclass)
        super
        subclass.initial_endpoint_setup
      end
    end
  end
end

require_relative "endpoint/version"
require_relative "endpoint/protocol"
require_relative "endpoint/adapter"
require_relative "endpoint/dsl"
