module Twitter::API::Endpoint
  class Adapter < Trailblazer::Endpoint::Adapter
    def unauthenticated(_ctx, api:, **)
      api.error!('401 Unauthorized', 401)
    end

    def success(_ctx, api:, model:, representer_class:, **)
      api.body(representer_class.new(model))
    end

    def invalid_data(_ctx, api:, contract:, **)
      api.error!(contract.errors.full_messages, 422)
    end
  end
end
