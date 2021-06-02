class ApplicationAdapter < Trailblazer::Endpoint::Adapter
  def unauthenticated(_ctx, controller:, **)
    controller.head(:unauthorized)
  end

  def unauthorized(_ctx, controller:, domain_ctx:, **)
    controller.render(plain: "#{domain_ctx[:current_user].id} isn't allowed access!", status: :unauthorized)
  end

  def not_found(_ctx, controller:, **)
    controller.head(:not_found)
  end

  def invalid_data(_ctx, controller:, domain_ctx:, **)
    controller.render(plain: domain_ctx[:contract].errors.full_messages, status: :unprocessable_entity)
  end

  def failure(_ctx, controller:, domain_ctx:, **)
    controller.render(plain: domain_ctx[:error], status: :unprocessable_entity)
  end

  def success(_ctx, controller:, model:, representer_class:, **)
    controller.render(json: representer_class.new(model))
  end
end
