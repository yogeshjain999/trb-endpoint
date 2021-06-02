module Trailblazer
  module Endpoint
    # Basic domain template activity which registers emittable {ends}
    # which will be inherited in actual domain activity.
    class DomainTemplate < FastTrack
      NOOP = ->(*) { true }

      step NOOP, id: :model,    Output(:failure) => End(:not_found)
      step NOOP, id: :policy,   Output(:failure) => End(:unauthorized)
      step NOOP, id: :contract, Output(:failure) => End(:invalid_data)
    end

    class Protocol < FastTrack
      step :authenticate,
        input: :authenticate_input,
        Output(:failure) => End(:unauthenticated)

      step Subprocess(DomainTemplate),
        id: :domain,
        input: :domain_input,
        output: :domain_output,
        output_with_outer_ctx: true,
        Output(:not_found)    => End(:not_found),
        Output(:unauthorized) => End(:unauthorized),
        Output(:invalid_data) => End(:invalid_data)

      def authenticate(*)
        raise StepNotDefined.new("Protocol", __callee__)
      end

      # Flatten and pass `endpoint_ctx` in all protocol steps to make
      # options like `controller` accessible from `ctx`.
      def authenticate_input(_ctx, endpoint_ctx:, domain_ctx:, **)
        endpoint_ctx.merge(domain_ctx: domain_ctx)
      end

      # Don't pass `endpoint_ctx` in domain!
      def domain_input(_ctx, domain_ctx:, **)
        domain_ctx
      end

      # Update `domain_ctx` with any mutations happened inside domain activity.
      def domain_output(inner_ctx, outer_ctx, **)
        outer_ctx.merge(domain_ctx: inner_ctx)
      end

      # Protocol having mandatory authorization before calling domain activity.
      class WithAuthorization < self
        step :authorize,
          after: :authenticate,
          Output(:failure) => End(:unauthorized)

        def authorize(*)
          raise StepNotDefined.new("Protocol", __callee__)
        end
      end
    end
  end
end
