require "minitest/autorun"
require "rack/test"

config_path = File.expand_path(File.join(__FILE__, '../../config.ru'))
Rack::Builder.parse_file(config_path).first

Minitest::Spec.class_eval do
  include Rack::Test::Methods

  def app
    Twitter::API
  end

  def encode_basic_auth(username, password)
    'Basic ' + Base64.encode64("#{username}:#{password}")
  end
end
