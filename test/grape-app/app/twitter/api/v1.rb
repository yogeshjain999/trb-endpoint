module Twitter
  class API::V1 < Grape::API
    mount Timeline  => "/timeline"
    mount Status    => "/status"
  end
end
