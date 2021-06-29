require "trailblazer/context"

module Trailblazer
  module Endpoint
    module Runner
      def run_endpoint(
        activity,
        invoke_class: get_directive_for(:invoke_class),
        **options
      )
        invoke_class.invoke(
          get_endpoint_for(activity),
          [default_ctx(**options), get_directive_for(:flow_options)]
        )
      end

      private

      def default_ctx(domain_ctx: get_directive_for(:domain_ctx), endpoint_ctx: get_directive_for(:endpoint_ctx), **)
        Trailblazer::Context(
          {
            domain_ctx: get_directive_for(:domain_ctx).merge(domain_ctx),
            endpoint_ctx: get_directive_for(:endpoint_ctx).merge(endpoint_ctx)
          }
        )
      end

      def endpoint_controller
        self.class
      end

      def get_endpoint_for(activity)
        endpoint_controller.get_endpoint_for(activity)
      end

      def get_directive_for(name)
        endpoint_controller.get_directive_for(name).(exec_context: self) # Trailblazer::Option.call
      end
    end
  end
end
