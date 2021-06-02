# Twitter::API example taken from official grape documentation.
module Twitter
  class API < Grape::API
    format :json
    mount V1 => "/v1"
  end
end
