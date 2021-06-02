module Trailblazer
  module Endpoint
    class Adapter < FastTrack
      step Subprocess(Protocol),
        id: :protocol,
        output: :protocol_output,
        Output(:unauthenticated)  => Track(:unauthenticated),
        Output(:not_found)        => Track(:not_found),
        Output(:unauthorized)     => Track(:unauthorized),
        Output(:invalid_data)     => Track(:invalid_data)

      step :unauthenticated,        id: :unauthenticated,       magnetic_to: :unauthenticated,        pass_fast: true
      step :not_found,              id: :not_found,             magnetic_to: :not_found,              pass_fast: true
      step :unauthorized,           id: :unauthorized,          magnetic_to: :unauthorized,           pass_fast: true
      step :invalid_data,           id: :invalid_data,          magnetic_to: :invalid_data,           pass_fast: true
      # step :internal_server_error,  id: :internal_server_error, magnetic_to: :internal_server_error,  pass_fast: true
      step :success,                id: :success,                                                     pass_fast: true
      fail :failure,                id: :failure,                                                     fail_fast: true

      def render(*)
        raise StepNotDefined.new("Adapter", __callee__)
      end

      %i[unauthenticated unauthorized not_found invalid_data failure success].each do |step|
        alias_method step, :render
      end

      # Make both `domain_ctx` and `endpoint_ctx` available in adapter renderers.
      def protocol_output(ctx, endpoint_ctx:, domain_ctx:, **)
        ctx.merge(endpoint_ctx).merge(domain_ctx)
      end
    end
  end
end
