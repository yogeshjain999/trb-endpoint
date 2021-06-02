module Timeline::Operation
  class Personal < Trailblazer::Operation
    step :model

    def model(ctx, current_user:, params:, **)
      ctx[:model] = Status.load(user: current_user, limit: params[:limit].to_i)
    end
  end
end
