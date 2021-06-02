module Twitter::API::Endpoint
  class Protocol < Trailblazer::Endpoint::Protocol
    def authenticate(ctx, api:, domain_ctx:, **)
      if api.headers["Api-Key"] == "secret"
        ctx[:domain_ctx][:current_user] = User.new(1, "tom-1@gmail.com")
      end
    end

    class NoAuth < self
      step nil, delete: :authenticate
    end
  end
end
