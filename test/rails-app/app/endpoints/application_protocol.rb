class ApplicationProtocol < Trailblazer::Endpoint::Protocol
  def authenticate(ctx, controller:, domain_ctx:, **)
    if controller.request.headers["api-key"] == "secret"
      domain_ctx[:current_user] = User.new(1, :tom)
    end
  end

  class WithAuthorization < Trailblazer::Endpoint::Protocol::WithAuthorization
    def authenticate(ctx, controller:, domain_ctx:, **)
      domain_ctx[:current_user] = controller.current_user
    end

    def authorize(_ctx, domain_ctx:, **)
      domain_ctx[:current_user].role == "admin"
    end
  end

  class NoAuth < self
    step nil, delete: :authenticate
  end
end
