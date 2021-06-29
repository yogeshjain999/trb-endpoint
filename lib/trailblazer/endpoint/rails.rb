require_relative '../endpoint'

module Trailblazer
  module Endpoint
    module Rails
      def self.included(controller)
        controller.extend Directive
        controller.extend Directive::Defaults
        controller.extend Compiler
        controller.include Runner

        controller.extend Inherited
      end

      module Inherited
        def inherited(sub_controller)
          super

          sub_controller.instance_variable_set(:@_trailblazer_endpoints, @_trailblazer_endpoints.dup)
          sub_controller.instance_variable_set(:@_trailblazer_directives, @_trailblazer_directives.dup)
        end
      end
    end
  end
end
