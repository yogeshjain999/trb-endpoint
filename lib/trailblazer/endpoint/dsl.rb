module Trailblazer
  module Endpoint
    class DSL
      def initialize(controller, name, adapter:, **options)
        @controller = controller
        @name       = name
        @adapter    = adapter
        @options    = options
      end

      # Override adapter's step for given `signal` and recompile
      # endpoint.
      #
      # compile_endpoint(Create).
      #   output(:not_found) { |ctx, errror:, **| ... }.
      #   output(:success) { |ctx, model:, **| ... }
      def output(signal, &block)
        adapter = Class.new(@adapter) do
          step block, id: signal, replace: signal, magnetic_to: signal, inherit: true
        end

        @controller.compile_endpoint(@name, adapter: adapter, **@options)
      end

      def Or(&block)
        protocol = @options.fetch(:protocol)

        adapter = Class.new(@adapter) do
          step Endpoint::Protocol(
            activity: protocol,
            outputs: protocol::BINARY_OUTPUTS
          ), id: :protocol, replace: :protocol, inherit: true

          fail block, id: :failure, replace: :failure, inherit: true
        end

        @controller.compile_endpoint(@name, adapter: adapter, **@options)
      end
    end
  end
end
