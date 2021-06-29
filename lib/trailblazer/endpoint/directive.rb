require "trailblazer-option"

module Trailblazer
  module Endpoint
    module Directive
      def self.extended(base)
        base.initial_directive_setup
      end

      module Defaults
        def self.extended(base)
          base.directive :invoke_class, Trailblazer::Activity::TaskWrap
          base.directive :endpoint_ctx, Hash.new 
          base.directive :domain_ctx,   Hash.new 
          base.directive :flow_options, Hash.new
        end
      end

      def directive(name, value = nil, &block)
        return set_directive_for(name, block) unless value

        set_directive_for(name, value)
      end

      def directives(**map)
        map.each { |name, value| set_directive_for(name, value) }
      end

      def initial_directive_setup
        @_trailblazer_directives = {}
      end

      def set_directive_for(name, value)
        @_trailblazer_directives[name] = Option(value)
      end

      def get_directive_for(name)
        @_trailblazer_directives.fetch(name)
      end

      def Option(value)
        Option.build(value)
      end

      class Option < ::Trailblazer::Option
        # Hmm, this is overriden in cells & representable too
        def self.build(value)
          callable = case value
                     when Proc, Symbol
                       value
                     else
                       ->(*) { value } # Make non-callable value into callable.
                     end

          super(callable)
        end
      end
    end
  end
end
