module Trailblazer
  module Endpoint
    class Adapter < FastTrack
      step Endpoint::Protocol(
        activity: Protocol,
        outputs: Protocol::OUTPUTS
      ), id: :protocol

      def render(*)
        raise StepNotDefined.new("Adapter", __callee__)
      end

      Protocol::OUTPUTS.each do |semantic|
        step semantic, magnetic_to: semantic, Output(:success) => End(semantic)
        alias_method semantic, :render
      end
    end
  end
end
