require "grape"
require "zeitwerk"

require "trailblazer"
require "trailblazer/endpoint/grape"

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/app")
loader.push_dir("#{__dir__}/app/models")
loader.push_dir("#{__dir__}/app/concepts")

loader.inflector.inflect("api" => "API")
loader.setup

Twitter::API.compile!
run Twitter::API
