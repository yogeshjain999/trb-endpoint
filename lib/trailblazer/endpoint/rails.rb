require_relative '../endpoint'

module Trailblazer
  module Endpoint
    module Rails
      def self.included(controller)
        controller.extend Directive
        controller.extend Directive::Inherited
        controller.extend Directive::Defaults
        controller.extend Compiler
        controller.extend Compiler::Inherited

        controller.include Runner
      end
    end
  end
end
