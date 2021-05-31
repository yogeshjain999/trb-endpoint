# frozen_string_literal: true

require "test_helper"

class Trailblazer::EndpointTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Trailblazer::Endpoint::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
