module Timeline::Operation
  class Public < Trailblazer::Operation
    step :model

    def model(ctx, params:, **)
      ctx[:model] = Status.load(user: nil, limit: params[:limit].to_i)
    end
  end
end
